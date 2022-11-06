#!/usr/bin/env bash

pesan() {
    echo -e "\e[1;32m$*\e[0m"
}

nama_rom=$(grep init $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d / -f 4)
nama_perangkat=$(grep lunch $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)

gagal=$(grep 'FAILED:' $WORKDIR/rom/$nama_rom/build.log -m1 || true)
if [[ $gagal == *'FAILED:'* ]]; then
    cd $WORKDIR/rom/$nama_rom
    echo 
    pesan ⛔ Building gagal!
    echo 
    curl -F document=@build.log "https://api.telegram.org/bot${TG_TOKEN}/sendDocument" \
    -F chat_id="${TG_CHAT_ID}" \
    -F "disable_web_page_preview=true" \
    -F "parse_mode=html" \
    -F caption="⛔${nama_perangkat} Build $nama_rom Error!!! "
fi

sukses=$(grep '#### build completed successfully' $WORKDIR/rom/$nama_rom/build.log -m1 || true)
if [[ $sukses == *'#### build completed successfully'* ]]; then
    echo 
    pesan ✅ Building selesai 100%
    echo 
    
    else

    echo 
    pesan ❌ Building belum selesai...
    echo 
    echo Kami melanjutkan untuk mengunggah ccache 
fi
