DIR_CONFIG="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR_CONFIG" ]]; then DIR_CONFIG="$PWD"; fi

[ -z "$FUNCTION_MODULE" ] && . "../tools/functions.sh"
[ -z "$VARIABLE_MODULE" ] && . "../variables.sh"

. "$DIR_CONFIG/connection.sh"
. "$DIR_CONFIG/podidentity/aadpodidentity.sh"
. "$DIR_CONFIG/keyvault-csi-driver/keyvault-csi-driver.sh"
. "$DIR_CONFIG/kured/kured.sh"
. "$DIR_CONFIG/keda/keda.sh"
. "$DIR_CONFIG/ingress-controller/ingress-controller.sh"
. "$DIR_CONFIG/dapr/dapr.sh"
