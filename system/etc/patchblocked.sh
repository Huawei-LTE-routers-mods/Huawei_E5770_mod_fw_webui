#!/system/bin/busybox sh

# This script is suitable for sourcing from another script.

PAGEMAP="$(awk '/r page00/ {print "0x"$1;exit}' /proc/kallsyms)"

function wr_m() {
    local i
    local dst
    local src

    dst=$(( ${1} ))
    shift
    for i in "$@";
    do
        src=$(( $PAGEMAP + 0x${i} ))
        ecall strncpy $dst $src 1 || true
        dst=$(( $dst + 1 ))
    done
}

if [[ "$1" == "boot" ]];
then
    # Patch datalock
    DATALOCK_ADDR="$(awk '/ g_bAtDataLocked/ {print "0x"$1;exit}' /proc/kallsyms)"
    if [[ "$DATALOCK_ADDR" ]];
    then
        # write zero to g_bAtDataLocked byte
        wr_m $DATALOCK_ADDR 00
        echo "Datalock patched"
    fi

    # Patch nv_readEx
    NV_READEX_ADDR="$(awk '/ nv_readEx/ {print "0x"$1;exit}' /proc/kallsyms)"
    if [[ "$NV_READEX_ADDR" ]];
    then
        NV_READEX_PATCH_OFFSET=$(($NV_READEX_ADDR + 0x54))
        # BLS loc_C0227A84 to NOP
        wr_m $NV_READEX_PATCH_OFFSET 00 00 A0 E1
        echo "nv_readEx patched"
    fi

    # Patch nv_writeEx
    NV_WRITEEX_ADDR="$(awk '/ nv_writeEx/ {print "0x"$1;exit}' /proc/kallsyms)"
    if [[ "$NV_WRITEEX_ADDR" ]];
    then
        NV_WRITEEX_PATCH_OFFSET=$(($NV_WRITEEX_ADDR + 0x4C))
        # BLS loc_C0227EE0 to NOP
        wr_m $NV_WRITEEX_PATCH_OFFSET 00 00 A0 E1
        echo "nv_writeEx patched"
    fi
    
    # Patch 'finger' Android USB gadget to use 'ecm' instead
    # Needed for ECM USB autoswitch
    # See drivers/usb/mbb_usb_unitary/hw_pnp_adapt.{c,h} to learn more
    # HACK: hardcoded offset for E5770 21.329.01.00.00
    wr_m 0xC070FA28 65 63 6D 00
fi
