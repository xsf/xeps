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
# requires: bash, xmllint

set -euo pipefail

VALIDATION_RESULT=0

# 1. Check DTD conformance against xep.dtd
XEP_DTD="xep.dtd"
if xmllint --noout --dtdvalid "$XEP_DTD" "$1"
then
  echo "[PASS] DTD conformance against xep.dtd"
else
  echo "[FAIL] DTD conformance against xep.dtd"
  VALIDATION_RESULT=1;
fi

FILE_NAME=$(basename -- "$1")
HEADER_NUMBER=$(xmllint --xpath '/xep/header/number/text()' --nowarning --dtdvalid "$XEP_DTD" "$1")
HEADER_STATUS=$(xmllint --xpath '/xep/header/status/text()' --nowarning --dtdvalid "$XEP_DTD" "$1")
HEADER_TYPE=$(xmllint --xpath '/xep/header/type/text()' --nowarning --dtdvalid "$XEP_DTD" "$1")
HEADER_APPROVER=$(xmllint --xpath '/xep/header/approver/text()' --nowarning --dtdvalid "$XEP_DTD" "$1")

if echo "$FILE_NAME" | grep -Eq "^xep-[0-9]{4}.xml$"
then
  echo "[INFO] The filename ('$FILE_NAME') matches 'xep-[0-9]{4}.xml'."
  # 2. If the filename matches xep-[0-9]{4}.xml, check:
  # 2.1 that the number in the filename equals /xep/header/number (XPath)
  if [ "$FILE_NAME" = "xep-$HEADER_NUMBER.xml" ]
  then
    echo "[PASS] The number in the filename ('$FILE_NAME') equals XPATH value /xep/header/number/text() ('$HEADER_NUMBER')."
  else
    echo "[FAIL] The number in the filename ('$FILE_NAME') does not equals XPATH value /xep/header/number/text() ('$HEADER_NUMBER') (but should)."
    VALIDATION_RESULT=1;
  fi
else
  echo "[INFO] The filename ('$FILE_NAME') does not match 'xep-[0-9]{4}.xml'."
  # 3. If the filename does not match xep-[0-9]{4}.xml, check:
  # 3.1 That the /xep/header/status/text() (XPath) is ProtoXEP
  if [ "$HEADER_STATUS" = "ProtoXEP" ]
  then
    echo "[PASS] XPATH value /xep/header/status/text() ('$HEADER_STATUS') equals 'ProtoXEP'."
  else
    echo "[FAIL] XPATH value /xep/header/status/text() ('$HEADER_STATUS') does not equal 'ProtoXEP' (but should)."
    VALIDATION_RESULT=1;
  fi

  # 3.2 That the /xep/header/number/text() (XPath) is literally XXXX
  if [ "$HEADER_NUMBER" = "XXXX" ]
  then
    echo "[PASS] XPATH value /xep/header/number/text() ('$HEADER_STATUS') equals 'XXXX'."
  else
    echo "[FAIL] XPATH value /xep/header/nimber/text() ('$HEADER_STATUS') does not equal 'XXXX' (but should)."
    VALIDATION_RESULT=1;
  fi

  # 3.3 That the name does not start with xep-[0-9]
  if echo "$FILE_NAME" | grep -Eq "^xep-[0-9].*$"
  then
    echo "[FAIL] The filename ('$FILE_NAME') starts with 'xep-[0-9]' (but should not)."
    VALIDATION_RESULT=1;
  else
    echo "[PASS] The filename ('$FILE_NAME') does not start with 'xep-[0-9]'."
  fi
fi

# 4. Check that /xep/header/status/text() (XPath) is a defined status (see tools/xeplib.py for an enum)
case $HEADER_STATUS in
  ProtoXEP | Experimental | Proposed | Draft | Active | Final | Retracted | Obsolete | Deferred | Rejected | Deprecated )
    echo "[PASS] XPATH value /xep/header/status/text() ('$HEADER_STATUS') equals a defined status."
    ;;
  *)
    echo "[FAIL] XPATH value /xep/header/status/text() ('$HEADER_STATUS') does not equals a defined status (but should)."
    VALIDATION_RESULT=1;
    ;;
esac

# 5. Check that /xep/header/type/text() (XPath) is defined in XEP-0001
#    If the XEP number is less than 400, also accept some legacy values. To find which, see which you encounter in the XEP numbers below 400 :-).
echo "[INFO] implementation of validation of XPATH value /xep/header/type/text() ('$HEADER_TYPE') is pending!"

# 6. Check that /xep/header/approver/text() (XPath) is either Board or Council
case $HEADER_APPROVER in
  Board | Council )
    echo "[PASS] XPATH value /xep/header/approver/text() ('$HEADER_APPROVER') equals either 'Board' or 'Council'."
    ;;
  *)
    echo "[FAIL] XPATH value /xep/header/approver/text() ('$HEADER_APPROVER') does not equals 'Board' or 'Council' (but should)."
    VALIDATION_RESULT=1;
    ;;
esac

# 7. Check that the version numbers in the revision blocks are descending (from top to bottom in the document)
echo "[INFO] implementation of validation version numbers in the revision blocks is pending!"

# 8. If the approver (see above) is Board, enforce that /xep/header/type is not Standards Track.
if [ "$HEADER_APPROVER" = "Board" ]
then
  if [ "$HEADER_TYPE" = "Standards Track" ]
  then
    echo "[FAIL] XPATH value /xep/header/approver/text() ('$HEADER_APPROVER') is 'Board' but XPATH value /xep/header/type/text() is 'Standards Track' (it should not be)."
    VALIDATION_RESULT=1;
  else
    echo "[PASS] XPATH value /xep/header/approver/text() ('$HEADER_APPROVER') is 'Board' and XPATH value /xep/header/type/text() is not 'Standards Track'."
  fi
fi

# 9. Check that it uses the xep.xsl XML stylesheet.
echo "[INFO] implementation of xep.xsl XML stylesheet usage is pending!"

# 10. Check that it includes the correct legal notice (either by checking for the entity reference, or by checking the content)
echo "[INFO] implementation of inclusion of correct legal notice is pending!"

echo ""
if [ $VALIDATION_RESULT = 0 ]
then
  echo "No issues found (but not all checks are implemented).";
else
  echo "Issues found!"
fi
exit $VALIDATION_RESULT
