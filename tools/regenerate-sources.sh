#!/bin/sh

# A script to re-build the text field sources from the source template file

# Stop on error
set -e

# The path where this script resides
script_path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# The path for the package (one level up)
package_path="$( cd -- "${script_path}/../" >/dev/null 2>&1 ; pwd -P )"

pushd .

# We have to run docbuild in the root of the source package
cd "${package_path}"

# Generate the NSTextField implementation
python3 ${script_path}/gyb --line-directive '' -D field_type="Text" -o "DSFFloatLabelledTextField.swift" "Sources/DSFFloatLabelledTextField/DSFFloatLabelledTextField.swift.gyb"
# Generate the NSSecureTextField implementation
python3 ${script_path}/gyb --line-directive '' -D field_type="SecureText" -o "DSFFloatLabelledSecureTextField.swift" "Sources/DSFFloatLabelledTextField/DSFFloatLabelledTextField.swift.gyb"

popd

echo "Done!"
