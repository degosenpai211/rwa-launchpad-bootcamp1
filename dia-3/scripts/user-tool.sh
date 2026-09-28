#!/usr/bin/env bash
# User tool — invocations signed by the investor / token holder.
# Usage: ./user-tool.sh <invest|balance|transfer> [amount]

set -euo pipefail

NETWORK="${NETWORK:-testnet}"
USER_KEY="${USER_KEY:-bob}"
CONTRACT_ID="${CONTRACT_ID:-C...DEPLOYED_LAUNCHPAD_CONTRACT_ID...}"
RECIPIENT="${RECIPIENT:-G...RECIPIENT_PUBLIC_KEY...}"

USER_ADDRESS="$(stellar keys address "$USER_KEY")"

invoke() {
  stellar contract invoke \
    --id "$CONTRACT_ID" \
    --source "$USER_KEY" \
    --network "$NETWORK" \
    -- "$@"
}

case "${1:-}" in
  invest)   invoke invest --investor "$USER_ADDRESS" --payment_amount "${2:-500}" ;;
  balance)  invoke balance --id "$USER_ADDRESS" ;;
  transfer) invoke transfer --from "$USER_ADDRESS" --to "$RECIPIENT" --amount "${2:-10}" ;;
  *)
    echo "Usage: $0 <invest|balance|transfer> [amount]" >&2
    exit 1
    ;;
esac
