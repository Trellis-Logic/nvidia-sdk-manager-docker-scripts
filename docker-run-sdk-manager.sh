#!/bin/bash
manager_ubuntu_18_tag="Ubuntu_18.04"
manager_ubuntu_20_tag="Ubuntu_20.04"
manager_os_tag=${manager_ubuntu_20_tag}
version="4.6.3"
target="JETSON_TX2_TARGETS"
target="JETSON_AGX_XAVIER_TARGETS"
response_template=$(dirname $0)/responsefiles/jp5/sdkm_responsefile_template.ini

if [[ "${version}" =~ 4.* ]]; then
    manager_os_tag=${manager_ubuntu_18_tag}
    echo "Response file using JP4, which requires Ubuntu 18.04 OS, using docker OS tag ${manager_os_tag}"
    response_template=responsefiles/jp4/sdkm_responsefile_template.ini
fi

tmpdir=$(mktemp -d)
manager_tag=$(docker images | grep sdkmanager | grep ${manager_os_tag} | head | awk '{print $2}')
if [ "${manager_tag}" == "" ]; then
    set -e
    echo "sdkmanager tag for OS ${manager_os_tag} not found."
    echo "Please download from https://developer.nvidia.com/drive/sdk-manager and place in the directory at ${tmpdir}"
    read -p "Press enter to continue"
    docker load -i ${tmpdir}/sdkmanager-*.tar.gz
fi

cp ${response_template} ${tmpdir}/responsefile.ini
sed "s/%version%/${version}/g; s/%target%/${target}/g" -i ${tmpdir}/responsefile.ini
echo "Running sdk manager ${manager_tag} with response file template ${responsefile}"
docker run -it \
    --rm \
    --privileged \
    -v /dev/bus/usb:/dev/bus/usb/ \
    -v /dev:/dev \
    -v ~:/home/nvidia/ \
    -v ${tmpdir}:${tmpdir} \
    sdkmanager:${manager_tag} \
    --cli install \
    --responsefile ${tmpdir}/responsefile.ini
rm -rf ${tmpdir}
