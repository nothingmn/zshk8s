FROM ubuntu:latest
LABEL maintainer="rob@damon.com"
LABEL version="0.1"
LABEL description="This is custom Docker Image for zsh with k8s, autocomplete, etc."
RUN apt update -y
RUN apt install -y --no-install-recommends \
	locales curl ca-certificates apt-transport-https git nano zsh wget openssh-client build-essential htop dnsutils \
        # .NET dependencies
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        #libicu66 \
        #libssl1.1 \
        libstdc++6 \
        zlib1g \
	#AWS \
	unzip \
	groff \
	mandoc \
	less





# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


#ohmyzsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
RUN chsh -s /bin/zsh

#kubectl
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl

#nodejs
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
RUN export NVM_DIR="$HOME/.nvm"

#dotnet
#RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
#RUN dpkg -i packages-microsoft-prod.deb
#RUN apt update
#RUN apt install -y dotnet-sdk-7.0
#RUN rm packages-microsoft-prod.deb
RUN wget https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh -O dotnet-install.sh
RUN chmod +x dotnet-install.sh
RUN mkdir /root/.dotnet
RUN mv dotnet-install.sh /root/.dotnet/


#Rust
#RUN wget https://sh.rustup.rs -O rustup-init.sh
#RUN chmod +x rustup-init.sh
#RUN sh rustup-init.sh -y
#RUN rm rustup-init.sh
#Rust version manager
RUN git clone https://github.com/sdepold/rsvm.git /root/.rsvm
RUN wget https://raw.github.com/sdepold/rsvm/master/install.sh
RUN chmod +x install.sh
RUN sh install.sh -y
RUN rm install.sh


#cheat sheet 
RUN wget https://cht.sh/:cht.sh -O cht.sh
RUN chmod +x cht.sh
RUN mv cht.sh /usr/bin/cheat.sh

#docker in docker
RUN curl -sSL https://get.docker.com/ | sh


#EKS - AWS Kubernetes https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
RUN mv /tmp/eksctl /usr/local/bin

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN sh ./aws/install
RUN rm awscliv2.zip

#Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh
RUN rm ./get_helm.sh

#kubens kubectx
RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx
RUN ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
RUN ln -s /opt/kubectx/kubens /usr/local/bin/kubens

RUN mkdir -p ~/.oh-my-zsh/completions
RUN chmod -R 755 ~/.oh-my-zsh/completions
RUN ln -s /opt/kubectx/completion/_kubectx.zsh ~/.oh-my-zsh/completions/_kubectx.zsh
RUN ln -s /opt/kubectx/completion/_kubens.zsh ~/.oh-my-zsh/completions/_kubens.zsh


#Kubetail
RUN git clone https://github.com/johanhaleby/kubetail.git /root/.oh-my-zsh/custom/plugins/kubetail



#copy over our .zshrc file
COPY ./zshrc /root/.zshrc

#copy over our .zshrc file
COPY .gitconfig /root/.gitconfig

# clean apt cache
RUN apt-get clean

#RUN echo "PS1='[\u@\h \W \$(kube_ps1)]\$ ':" >> ~/.zshrc
ENTRYPOINT ["/bin/zsh"]

