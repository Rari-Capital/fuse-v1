NOCOLOR='\033[0m'
YELLOW='\033[1;33m'

echo "${YELLOW}==========================================================="
echo "2/4 Creating Typescript configuration files"
echo "===========================================================${NOCOLOR}"

rm ./abi/packages/**/tsconfig-base.json
rm ./abi/packages/**/tsconfig-esm.json
rm ./abi/packages/**/tsconfig-cjs.json

cat ./scripts/abi/tsconfig/tsconfig-base.json >> ./abi/packages/arbitrum/tsconfig-base.json
cat ./scripts/abi/tsconfig/tsconfig-base.json >> ./abi/packages/core/tsconfig-base.json
cat ./scripts/abi/tsconfig/tsconfig-base.json >> ./abi/packages/liquidators/tsconfig-base.json
cat ./scripts/abi/tsconfig/tsconfig-base.json >> ./abi/packages/oracles/tsconfig-base.json
cat ./scripts/abi/tsconfig/tsconfig-base.json >> ./abi/packages/periphery/tsconfig-base.json
cat ./scripts/abi/tsconfig/tsconfig-base.json >> ./abi/packages/utils/tsconfig-base.json

cat ./scripts/abi/tsconfig/tsconfig-esm.json >> ./abi/packages/arbitrum/tsconfig-esm.json
cat ./scripts/abi/tsconfig/tsconfig-esm.json >> ./abi/packages/core/tsconfig-esm.json
cat ./scripts/abi/tsconfig/tsconfig-esm.json >> ./abi/packages/liquidators/tsconfig-esm.json
cat ./scripts/abi/tsconfig/tsconfig-esm.json >> ./abi/packages/oracles/tsconfig-esm.json
cat ./scripts/abi/tsconfig/tsconfig-esm.json >> ./abi/packages/periphery/tsconfig-esm.json
cat ./scripts/abi/tsconfig/tsconfig-esm.json >> ./abi/packages/utils/tsconfig-esm.json

cat ./scripts/abi/tsconfig/tsconfig-cjs.json >> ./abi/packages/arbitrum/tsconfig-cjs.json
cat ./scripts/abi/tsconfig/tsconfig-cjs.json >> ./abi/packages/core/tsconfig-cjs.json
cat ./scripts/abi/tsconfig/tsconfig-cjs.json >> ./abi/packages/liquidators/tsconfig-cjs.json
cat ./scripts/abi/tsconfig/tsconfig-cjs.json >> ./abi/packages/oracles/tsconfig-cjs.json
cat ./scripts/abi/tsconfig/tsconfig-cjs.json >> ./abi/packages/periphery/tsconfig-cjs.json
cat ./scripts/abi/tsconfig/tsconfig-cjs.json >> ./abi/packages/utils/tsconfig-cjs.json
