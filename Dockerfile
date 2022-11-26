FROM ubuntu:latest
LABEL maintainer="rob@damon.com"
LABEL version="0.1"
LABEL description="This is custom Docker Image for zsh with k8s, autocomplete, etc."
RUN apt update -y
RUN apt install -y --no-install-recommends \
	locales curl ca-certificates apt-transport-https git nano zsh wget openssh-client build-essential htop nslookup dig \
        # .NET dependencies
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        #libicu66 \
        #libssl1.1 \
        libstdc++6 \
        zlib1g


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
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt update
RUN apt install -y dotnet-sdk-7.0
RUN rm packages-microsoft-prod.deb

#Rust
RUN wget https://sh.rustup.rs -O rustup-init.sh
RUN chmod +x rustup-init.sh
RUN sh rustup-init.sh -y
RUN rm rustup-init.sh

#cheat sheet 
RUN wget https://cht.sh/:cht.sh -O cht.sh
RUN chmod +x cht.sh
RUN mv cht.sh /usr/bin/cht.sh

#copy over our .zshrc file
COPY ./zshrc /root/.zshrc

# clean apt cache
RUN apt-get clean

#RUN echo "PS1='[\u@\h \W \$(kube_ps1)]\$ ':" >> ~/.zshrc
ENTRYPOINT ["/bin/zsh"]

