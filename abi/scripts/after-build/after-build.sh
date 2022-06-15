GREEN='\033[0;32m'
NOCOLOR='\033[0m'
YELLOW='\033[1;33m'
echo "${YELLOW}==========================================================="
echo "4/4 Creating package.jsons"
echo "===========================================================${NOCOLOR}"

cat ./abi/scripts/after-build/cjs.json >> ./abi/packages/arbitrum/dist/cjs/package.json
cat ./abi/scripts/after-build/cjs.json >> ./abi/packages/core/dist/cjs/package.json
cat ./abi/scripts/after-build/cjs.json >> ./abi/packages/liquidators/dist/cjs/package.json
cat ./abi/scripts/after-build/cjs.json >> ./abi/packages/oracles/dist/cjs/package.json
cat ./abi/scripts/after-build/cjs.json >> ./abi/packages/periphery/dist/cjs/package.json
cat ./abi/scripts/after-build/cjs.json >> ./abi/packages/utils/dist/cjs/package.json

cat ./abi/scripts/after-build/esm.json >> ./abi/packages/arbitrum/dist/esm/package.json
cat ./abi/scripts/after-build/esm.json >> ./abi/packages/core/dist/esm/package.json
cat ./abi/scripts/after-build/esm.json >> ./abi/packages/liquidators/dist/esm/package.json
cat ./abi/scripts/after-build/esm.json >> ./abi/packages/oracles/dist/esm/package.json
cat ./abi/scripts/after-build/esm.json >> ./abi/packages/periphery/dist/esm/package.json
cat ./abi/scripts/after-build/esm.json >> ./abi/packages/utils/dist/esm/package.json

echo "${GREEN}==========================================================="
echo "Packages created successfully!"
echo "===========================================================${NOCOLOR}\a"