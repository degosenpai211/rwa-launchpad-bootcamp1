#!/usr/bin/env bash
# Admin tool — invocations that require the issuer/admin key to sign.
# Usage: ./admin-tool.sh <initialize|whitelist|mint|withdraw|pause|unpause> [amount]

set -euo pipefail

NETWORK="${NETWORK:-testnet}"
ADMIN_KEY="${ADMIN_KEY:-alice}"
CONTRACT_ID="${CONTRACT_ID:-C...DEPLOYED_LAUNCHPAD_CONTRACT_ID...}"
PAYMENT_TOKEN="${PAYMENT_TOKEN:-C...INSTRUCTOR_PAYMENT_TOKEN_ID...}"
INVESTOR="${INVESTOR:-G...INVESTOR_PUBLIC_KEY...}"
TREASURY="${TREASURY:-G...TREASURY_PUBLIC_KEY...}"

ADMIN_ADDRESS="$(stellar keys address "$ADMIN_KEY")"

invoke() {
  stellar contract invoke \
    --id "$CONTRACT_ID" \
    --source "$ADMIN_KEY" \
    --network "$NETWORK" \
    -- "$@"
}

initialize() {
  invoke initialize \
    --admin "$ADMIN_ADDRESS" \
    --asset '{"name":"RWAToken","total_supply":1000000,"price_per_unit":100,"payment_token":"'"$PAYMENT_TOKEN"'","paused":false}'
}

case "${1:-}" in
  initialize) initialize ;;
  whitelist)  invoke set_whitelist --admin "$ADMIN_ADDRESS" --investor "$INVESTOR" --approved true ;;
  mint)       invoke mint --admin "$ADMIN_ADDRESS" --to "$INVESTOR" --amount "${2:-100}" ;;
  withdraw)   invoke withdraw --admin "$ADMIN_ADDRESS" --to "$TREASURY" --amount "${2:-500}" ;;
  pause)      invoke pause --admin "$ADMIN_ADDRESS" ;;
  unpause)    invoke unpause --admin "$ADMIN_ADDRESS" ;;
  *)
    echo "Usage: $0 <initialize|whitelist|mint|withdraw|pause|unpause> [amount]" >&2
    exit 1
    ;;
esac
