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

# ANSI color definitions
ANSI_INFO='\033[1;94m';
ANSI_PASS='\033[1;92m';
ANSI_FAIL='\033[1;91m';
ANSI_RESET='\033[0m';

validation_result=0

echo -e "Start validating file '$1'."
echo ""

# 1. Check DTD conformance against xep.dtd
xep_dtd="xep.dtd"
if xmllint --noout --dtdvalid "$xep_dtd" "$1"
then
  echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} DTD conformance against xep.dtd"
else
  echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} DTD conformance against xep.dtd"
  validation_result=1;
fi

file_name=$(basename -- "$1")

# The test for exit code equalling 10 detects when the XPATH evaluation yields no results. In that case, the execution
# should not fail immediately, but use an empty value instead (which will likely cause a validation failure further down).
header_number=$(xmllint --xpath '/xep/header/number/text()' --nowarning --noent --dtdvalid "$xep_dtd" "$1") || test $?=10
header_status=$(xmllint --xpath '/xep/header/status/text()' --nowarning --dtdvalid "$xep_dtd" "$1") || test $?=10
header_type=$(xmllint --xpath '/xep/header/type/text()' --nowarning --dtdvalid "$xep_dtd" "$1") || test $?=10
header_approver=$(xmllint --xpath '/xep/header/approver/text()' --nowarning --dtdvalid "$xep_dtd" "$1") || test $?=10
header_revisions=$(xmllint --xpath '/xep/header/revision/version/text()' --nowarning --dtdvalid "$xep_dtd" "$1") || test $?=10
processing_instructions=$(xmllint --xpath '/processing-instruction("xml-stylesheet")' --nowarning --dtdvalid "$xep_dtd" "$1") || test $?=10

if echo "$file_name" | grep -Eq "^xep-[0-9]{4}.xml$"
then
  echo -e "${ANSI_INFO}[INFO]${ANSI_RESET} The filename ('$file_name') matches 'xep-[0-9]{4}.xml'."
  # 2. If the filename matches xep-[0-9]{4}.xml, check:
  # 2.1 that the number in the filename equals /xep/header/number (XPath)
  if [ "$file_name" = "xep-$header_number.xml" ]
  then
    echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} The number in the filename ('$file_name') equals XPATH value /xep/header/number/text() ('$header_number')."
  else
    echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} The number in the filename ('$file_name') does not equals XPATH value /xep/header/number/text() ('$header_number') (but should)."
    validation_result=1
  fi
else
  echo -e "${ANSI_INFO}[INFO]${ANSI_RESET} The filename ('$file_name') does not match 'xep-[0-9]{4}.xml'."
  # 3. If the filename does not match xep-[0-9]{4}.xml, check:
  # 3.1 That the /xep/header/status/text() (XPath) is ProtoXEP
  if [ "$header_status" = "ProtoXEP" ]
  then
    echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} XPATH value /xep/header/status/text() ('$header_status') equals 'ProtoXEP'."
  else
    echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} XPATH value /xep/header/status/text() ('$header_status') does not equal 'ProtoXEP' (but should)."
    validation_result=1
  fi

  # 3.2 That the /xep/header/number/text() (XPath) is literally XXXX or xxxx
  if [ "$header_number" = "XXXX" ] || [ "$header_number" = "xxxx" ]
  then
    echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} XPATH value /xep/header/number/text() ('$header_status') equals '$header_number'."
  else
    echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} XPATH value /xep/header/number/text() ('$header_status') does not equal 'XXXX' or 'xxxx' (but should)."
    validation_result=1
  fi

  # 3.3 That the name does not start with xep-[0-9]
  if echo "$file_name" | grep -Eq "^xep-[0-9].*$"
  then
    echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} The filename ('$file_name') starts with 'xep-[0-9]' (but should not)."
    validation_result=1
  else
    echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} The filename ('$file_name') does not start with 'xep-[0-9]'."
  fi
fi

# 4. Check that /xep/header/status/text() (XPath) is a defined status (see tools/xeplib.py for an enum)
case $header_status in
  ProtoXEP | Experimental | Proposed | Draft | Active | Final | Retracted | Obsolete | Deferred | Rejected | Deprecated )
    echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} XPATH value /xep/header/status/text() ('$header_status') equals a defined status."
    ;;
  *)
    echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} XPATH value /xep/header/status/text() ('$header_status') does not equals a defined status (but should)."
    validation_result=1
    ;;
esac

# 5. Check that /xep/header/type/text() (XPath) is defined in XEP-0001
#    If the XEP number is less than 400, also accept some legacy values. To find which, see which you encounter in the XEP numbers below 400 :-).

# FIXME: lots of duplications here. Find a better solution.
case $file_name in
  'xep-0001.xml' | 'xep-0002.xml' | 'xep-0019.xml' | 'xep-0053.xml' | 'xep-0143.xml' | 'xep-0182.xml' | 'xep-0345.xml' | 'xep-0381.xml' | 'xep-0429.xml' | 'xep-0458.xml' )
    case $header_type in
      Historical | Humorous | Informational | Organizational | 'Standards Track' | 'Procedural' )
        echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} XPATH value /xep/header/type/text() ('$header_type') equals a defined type."
        ;;
      *)
        echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} XPATH value /xep/header/type/text() ('$header_type') does not equals a defined type (but should)."
        validation_result=1
        ;;
    esac
    ;;
  'xep-0006.xml' | 'xep-0010.xml' | 'xep-0069.xml' | 'xep-0139.xml' )
    case $header_type in
      Historical | Humorous | Informational | Organizational | 'Standards Track' | 'SIG Formation' )
        echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} XPATH value /xep/header/type/text() ('$header_type') equals a defined type."
        ;;
      *)
        echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} XPATH value /xep/header/type/text() ('$header_type') does not equals a defined type (but should)."
        validation_result=1
        ;;
    esac
    ;;
  'xep-0007.xml' )
    case $header_type in
      Historical | Humorous | Informational | Organizational | 'Standards Track' | 'SIG Proposal' )
        echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} XPATH value /xep/header/type/text() ('$header_type') equals a defined type."
        ;;
      *)
        echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} XPATH value /xep/header/type/text() ('$header_type') does not equals a defined type (but should)."
        validation_result=1
        ;;
    esac
    ;;
  * )
    case $header_type in
      Historical | Humorous | Informational | Organizational | 'Standards Track' )
        echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} XPATH value /xep/header/type/text() ('$header_type') equals a defined type."
        ;;
      *)
        echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} XPATH value /xep/header/type/text() ('$header_type') does not equals a defined type (but should)."
        validation_result=1
        ;;
    esac
    ;;
esac

# 6. Check that /xep/header/approver/text() (XPath) is either Board or Council
case $header_approver in
  Board | Council )
    echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} XPATH value /xep/header/approver/text() ('$header_approver') equals either 'Board' or 'Council'."
    ;;
  *)
    echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} XPATH value /xep/header/approver/text() ('$header_approver') does not equals 'Board' or 'Council' (but should)."
    validation_result=1
    ;;
esac

# 7. Check that the version numbers in the revision blocks are descending (from top to bottom in the document)
expected_revision_order=$(echo "$header_revisions" | tr " " "\n" | sort -Vr)
if [ "$expected_revision_order" = "$header_revisions" ]
then
  echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} Version numbers in the revision blocks are descending."
else
  echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} Version numbers in the revision blocks are not ordered (descending from top to bottom in the document) (but should be)."
  echo "       Order found : $(echo $header_revisions)" # funky $() nesting to remove newlines.
  echo "       Expected was: $(echo $expected_revision_order)"
  validation_result=1
fi

# 8. If the approver (see above) is Board, enforce that /xep/header/type is not Standards Track.
if [ "$header_approver" = "Board" ]
then
  if [ "$header_type" = "Standards Track" ]
  then
    echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} XPATH value /xep/header/approver/text() ('$header_approver') is 'Board' but XPATH value /xep/header/type/text() is 'Standards Track' (it should not be)."
    validation_result=1
  else
    echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} XPATH value /xep/header/approver/text() ('$header_approver') is 'Board' and XPATH value /xep/header/type/text() is not 'Standards Track'."
  fi
fi

# 9. Check that it uses the xep.xsl XML stylesheet.
if echo "$processing_instructions" | grep -Eq "href=['\"]xep.xsl['\"]"
then
  echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} xep.xsl XML stylesheet is used."
else
  echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} xep.xsl XML stylesheet is not used (but should be)."
  validation_result=1
fi

# 10. Check that it includes the correct legal notice (by checking for the entity reference)
if grep -q "&LEGALNOTICE;" "$1"
then
  echo -e "${ANSI_PASS}[PASS]${ANSI_RESET} entity reference for the legal notice has been detected."
else
  echo -e "${ANSI_FAIL}[FAIL]${ANSI_RESET} entity reference for the legal notice has not been detected (but it should have been)."
  validation_result=1
fi

echo ""
if [ $validation_result = 0 ]
then
  echo "No issues found."
else
  echo "Issues found!"
fi
exit $validation_result
