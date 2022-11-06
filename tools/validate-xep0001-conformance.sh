#!/bin/bash

# Checks if provided file (filename to be provided as first argument) conforms to XEP-0001.
# See https://github.com/xsf/xeps/issues/1235
#
# Expected to be executed from the directory that holds all xep XML files.
# Requires one argument: the file name of the xep to be validated, eg:
#
# $ tools/validate-xep0001-conformance.sh xep-0010.xml
#
# exit status will be non-zero upon validation failure.
#
# requires: bash, xmllint, sort (supporting the '-V' argument)

set -euo pipefail

validation_result=0

# 1. Check DTD conformance against xep.dtd
xep_dtd="xep.dtd"
if xmllint --noout --dtdvalid "$xep_dtd" "$1"
then
  echo "[PASS] DTD conformance against xep.dtd"
else
  echo "[FAIL] DTD conformance against xep.dtd"
  validation_result=1;
fi

file_name=$(basename -- "$1")
header_number=$(xmllint --xpath '/xep/header/number/text()' --nowarning --dtdvalid "$xep_dtd" "$1")
header_status=$(xmllint --xpath '/xep/header/status/text()' --nowarning --dtdvalid "$xep_dtd" "$1")
header_type=$(xmllint --xpath '/xep/header/type/text()' --nowarning --dtdvalid "$xep_dtd" "$1")
header_approver=$(xmllint --xpath '/xep/header/approver/text()' --nowarning --dtdvalid "$xep_dtd" "$1")
header_revisions=$(xmllint --xpath '/xep/header/revision/version/text()' --nowarning --dtdvalid "$xep_dtd" "$1")
processing_instructions=$(xmllint --xpath '/processing-instruction("xml-stylesheet")' --nowarning --dtdvalid "$xep_dtd" "$1")

if echo "$file_name" | grep -Eq "^xep-[0-9]{4}.xml$"
then
  echo "[INFO] The filename ('$file_name') matches 'xep-[0-9]{4}.xml'."
  # 2. If the filename matches xep-[0-9]{4}.xml, check:
  # 2.1 that the number in the filename equals /xep/header/number (XPath)
  if [ "$file_name" = "xep-$header_number.xml" ]
  then
    echo "[PASS] The number in the filename ('$file_name') equals XPATH value /xep/header/number/text() ('$header_number')."
  else
    echo "[FAIL] The number in the filename ('$file_name') does not equals XPATH value /xep/header/number/text() ('$header_number') (but should)."
    validation_result=1
  fi
else
  echo "[INFO] The filename ('$file_name') does not match 'xep-[0-9]{4}.xml'."
  # 3. If the filename does not match xep-[0-9]{4}.xml, check:
  # 3.1 That the /xep/header/status/text() (XPath) is ProtoXEP
  if [ "$header_status" = "ProtoXEP" ]
  then
    echo "[PASS] XPATH value /xep/header/status/text() ('$header_status') equals 'ProtoXEP'."
  else
    echo "[FAIL] XPATH value /xep/header/status/text() ('$header_status') does not equal 'ProtoXEP' (but should)."
    validation_result=1
  fi

  # 3.2 That the /xep/header/number/text() (XPath) is literally XXXX
  if [ "$header_number" = "XXXX" ]
  then
    echo "[PASS] XPATH value /xep/header/number/text() ('$header_status') equals 'XXXX'."
  else
    echo "[FAIL] XPATH value /xep/header/nimber/text() ('$header_status') does not equal 'XXXX' (but should)."
    validation_result=1
  fi

  # 3.3 That the name does not start with xep-[0-9]
  if echo "$file_name" | grep -Eq "^xep-[0-9].*$"
  then
    echo "[FAIL] The filename ('$file_name') starts with 'xep-[0-9]' (but should not)."
    validation_result=1
  else
    echo "[PASS] The filename ('$file_name') does not start with 'xep-[0-9]'."
  fi
fi

# 4. Check that /xep/header/status/text() (XPath) is a defined status (see tools/xeplib.py for an enum)
case $header_status in
  ProtoXEP | Experimental | Proposed | Draft | Active | Final | Retracted | Obsolete | Deferred | Rejected | Deprecated )
    echo "[PASS] XPATH value /xep/header/status/text() ('$header_status') equals a defined status."
    ;;
  *)
    echo "[FAIL] XPATH value /xep/header/status/text() ('$header_status') does not equals a defined status (but should)."
    validation_result=1
    ;;
esac

# 5. Check that /xep/header/type/text() (XPath) is defined in XEP-0001
#    If the XEP number is less than 400, also accept some legacy values. To find which, see which you encounter in the XEP numbers below 400 :-).
echo "[INFO] implementation of validation of XPATH value /xep/header/type/text() ('$header_type') is pending!"

# 6. Check that /xep/header/approver/text() (XPath) is either Board or Council
case $header_approver in
  Board | Council )
    echo "[PASS] XPATH value /xep/header/approver/text() ('$header_approver') equals either 'Board' or 'Council'."
    ;;
  *)
    echo "[FAIL] XPATH value /xep/header/approver/text() ('$header_approver') does not equals 'Board' or 'Council' (but should)."
    validation_result=1
    ;;
esac

# 7. Check that the version numbers in the revision blocks are descending (from top to bottom in the document)
expected_revision_order=$(echo "$header_revisions" | tr " " "\n" | sort -Vr)
if [ "$expected_revision_order" = "$header_revisions" ]
then
  echo "[PASS] Version numbers in the revision blocks are descending."
else
  echo "[FAIL] Version numbers in the revision blocks are not ordered (descending from top to bottom in the document) (but should be)."
  echo "       Order found : $(echo $header_revisions)" # funky $() nesting to remove newlines.
  echo "       Expected was: $(echo $expected_revision_order)"
  validation_result=1
fi

# 8. If the approver (see above) is Board, enforce that /xep/header/type is not Standards Track.
if [ "$header_approver" = "Board" ]
then
  if [ "$header_type" = "Standards Track" ]
  then
    echo "[FAIL] XPATH value /xep/header/approver/text() ('$header_approver') is 'Board' but XPATH value /xep/header/type/text() is 'Standards Track' (it should not be)."
    validation_result=1
  else
    echo "[PASS] XPATH value /xep/header/approver/text() ('$header_approver') is 'Board' and XPATH value /xep/header/type/text() is not 'Standards Track'."
  fi
fi

# 9. Check that it uses the xep.xsl XML stylesheet.
if echo "$processing_instructions" | grep -Eq "href=['\"]xep.xsl['\"]"
then
  echo "[PASS] xep.xsl XML stylesheet is used."
else
  echo "[FAIL] xep.xsl XML stylesheet is not used (but should be)."
  validation_result=1
fi

# 10. Check that it includes the correct legal notice (either by checking for the entity reference, or by checking the content)
echo "[INFO] implementation of inclusion of correct legal notice is pending!"

echo ""
if [ $validation_result = 0 ]
then
  echo "No issues found (but not all checks are implemented)."
else
  echo "Issues found!"
fi
exit $validation_result
