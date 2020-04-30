FROM photon:3.0
  
LABEL authors="renoufa@vmware.com,jaker@vmware.com,admin@virt.ninja"

ENV TERM linux

WORKDIR /root

# Set terminal. If we don't do this, weird readline things happen.
RUN echo "/usr/bin/pwsh" >> /etc/shells && \
    echo "/bin/pwsh" >> /etc/shells && \
    tdnf install -y powershell-6.2.3-1.ph3 unzip && \
    pwsh -c "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted" && \
    pwsh -c "\$ProgressPreference = \"SilentlyContinue\"; Install-Module VMware.PowerCLI -RequiredVersion 12.0.0.15947286" && \
    pwsh -c "\$ProgressPreference = \"SilentlyContinue\"; Install-Module PowerNSX -RequiredVersion 3.0.1174" && \
    pwsh -c "\$ProgressPreference = \"SilentlyContinue\"; Install-Module PowervRA -RequiredVersion 4.0.0" && \
    pwsh -c "\$ProgressPreference = \"SilentlyContinue\"; Install-Module vmxtoolkit -RequiredVersion 4.5.3.1" && \
    curl -o ./PowerCLI-Example-Scripts.zip -J -L https://github.com/vmware/PowerCLI-Example-Scripts/archive/03272c1d2db26a525b31c930e3bf3d20d34468e0.zip && \
    unzip PowerCLI-Example-Scripts.zip && \
    rm -f PowerCLI-Example-Scripts.zip && \
    mv ./PowerCLI-Example-Scripts-* ./PowerCLI-Example-Scripts && \
    mv ./PowerCLI-Example-Scripts/Modules/* /usr/lib/powershell/Modules/ && \
    find / -name "net45" | xargs rm -rf && \
    curl -o ./vghetto-vsphere-with-kubernetes-external-nsxt-lab-deployment.ps1 -J -L https://raw.githubusercontent.com/virt-ninja/vghetto-vsphere-with-kubernetes-external-nsxt-automated-lab-deployment/master/vghetto-vsphere-with-kubernetes-external-nsxt-lab-deployment.ps1 && \
    tdnf erase -y unzip && \
    tdnf clean all


CMD ["/bin/pwsh"]
