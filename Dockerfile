FROM golang:1.18-alpine AS builder
RUN apk update && apk add --no-cache make ca-certificates build-base git
WORKDIR /go/src/github.com/aura-nw/bdaura
COPY . ./

######################################################
## Enable the lines below if chain supports cosmwasm ##
## module to properly build docker image            ##
######################################################
## RUN apk update && apk add --no-cache ca-certificates build-base git
ADD https://github.com/CosmWasm/wasmvm/releases/download/v1.1.1/libwasmvm_muslc.aarch64.a /lib/libwasmvm_muslc.aarch64.a
ADD https://github.com/CosmWasm/wasmvm/releases/download/v1.1.1/libwasmvm_muslc.x86_64.a /lib/libwasmvm_muslc.x86_64.a
RUN sha256sum /lib/libwasmvm_muslc.aarch64.a | grep 9ecb037336bd56076573dc18c26631a9d2099a7f2b40dc04b6cae31ffb4c8f9a
RUN sha256sum /lib/libwasmvm_muslc.x86_64.a | grep 6e4de7ba9bad4ae9679c7f9ecf7e283dd0160e71567c6a7be6ae47c81ebe7f32
## Copy the library you want to the final location that will be found by the linker flag `-lwasmvm_muslc`
RUN cp /lib/libwasmvm_muslc.$(uname -m).a /lib/libwasmvm_muslc.a

RUN go mod download
## RUN make build

##################################################
## Enable line below if chain supports cosmwasm  ##
## module to properly build docker image        ##
##################################################
RUN LINK_STATICALLY=true BUILD_TAGS="muslc" make build


FROM alpine:latest
##################################################
## Enable line below if chain supports cosmwasm  ##
## module to properly build docker image        ##
##################################################
RUN apk update && apk add --no-cache ca-certificates build-base
WORKDIR /bdaura
COPY --from=builder /go/src/github.com/aura-nw/bdaura/build/bdaura /usr/bin/bdaura

RUN bdaura init
RUN wget https://github.com/aura-nw/testnets/raw/main/serenity-testnet-001/6-July-upgrade/state.tar.gz
RUN tar -zxf state.tar.gz
RUN mv genesis.json $HOME/.bdaura/genesis.json

RUN rm -rf $HOME/.bdaura/config.yaml
## COPY --from=builder /go/src/github.com/aura-nw/bdaura /root
## RUN cp $HOME/config.yaml $HOME/.bdaura
## RUN bdaura parse genesis-file --genesis-file-path $HOME/.bdaura/genesis.json

## RUN go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest

CMD [ "bdaura", "start" ]