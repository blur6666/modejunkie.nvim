FROM archlinux:latest

RUN pacman -Syu --noconfirm neovim git ripgrep fd nodejs npm unzip curl wget base-devel

WORKDIR /root

COPY nvim-config /root/.config/nvim

ENV TERM=xterm-256color
ENV COLORTERM=truecolor

CMD ["nvim"]
