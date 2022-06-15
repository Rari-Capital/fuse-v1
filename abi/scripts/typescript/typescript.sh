GREEN='\033[0;32m'
NOCOLOR='\033[0m'
YELLOW='\033[1;33m'

echo "${YELLOW}==========================================================="
echo "3/4 Compiling packages"
echo "===========================================================${NOCOLOR}"

echo "\n${GREEN}Compiling arbitrum contracts${NOCOLOR}"
npm run build --workspace=abi/packages/arbitrum

echo "\n${GREEN}Compiling core contracts${NOCOLOR}"
npm run build --workspace=abi/packages/core

echo "\n${GREEN}Compiling liquidators contracts${NOCOLOR}"
npm run build --workspace=abi/packages/liquidators

echo "\n${GREEN}Compiling oracles contracts${NOCOLOR}"
npm run build --workspace=abi/packages/oracles

echo "\n${GREEN}Compiling periphery contracts${NOCOLOR}"
npm run build --workspace=abi/packages/periphery

echo "\n${GREEN}Compiling utils contracts${NOCOLOR}"
npm run build --workspace=abi/packages/utils