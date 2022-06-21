GREEN='\033[0;32m'
NOCOLOR='\033[0m'
YELLOW='\033[1;33m'
RED='\033[0;31m'

echo "${RED}==========================================================="
echo "                USE NODE V 16.0.0 OR LATER"
echo "===========================================================${NOCOLOR}\a"

echo "${YELLOW}==========================================================="
echo "1/4 Running Typechain"
echo "===========================================================${NOCOLOR}"
echo "\n${GREEN}Building typechain for preiphery contracts${NOCOLOR}"
npx typechain --target=ethers-v5 './abi/src/*.json' --out-dir="./abi/packages/periphery/src"

echo "\n${GREEN}Building typechain for the oracle contracts${NOCOLOR}"
npx typechain --target=ethers-v5 './abi/src/oracles/*.json' --out-dir="./abi/packages/oracles/src"

echo "\n${GREEN}Building typechain for the liquidator contracts${NOCOLOR}"
npx typechain --target=ethers-v5 './abi/src/liquidators/*.json' --out-dir="./abi/packages/liquidators/src"

echo "\n${GREEN}Building typechain for the core contracts${NOCOLOR}"
npx typechain --target=ethers-v5 './abi/src/core/*.json' --out-dir="./abi/packages/core/src"

echo "\n${GREEN}Building typechain for arbitrum contracts${NOCOLOR}"
npx typechain --target=ethers-v5 './abi/src/arbitrum/*.json' --out-dir="./abi/packages/arbitrum/src"

echo "\n${GREEN}Building typechain for utility contracts${NOCOLOR}"
npx typechain --target=ethers-v5 './abi/src/utils/*.json' --out-dir="./abi/packages/utils/src"
