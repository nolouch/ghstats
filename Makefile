.PHONY: build

path_to_add := $(addsuffix /bin,$(subst :,/bin:,$(GOPATH)))
export PATH := $(path_to_add):$(PATH)

SHELL	 := /usr/bin/env bash

GO       := GO111MODULE=on go
ifeq (${ENABLE_VENDOR}, 1)
GOVENDORFLAG := -mod=vendor
endif

ifeq (${TRIMPATH}, 1)
GOTRIMPATH := -trimpath
endif

GOBUILD := CGO_ENABLED=0 $(GO) build $(BUILD_FLAG) ${GOTRIMPATH} $(GOVENDORFLAG)

build: tidy
	$(GOBUILD) -ldflags '$(LDFLAGS)' -o bin/gh ./main.go

tidy:
	$(GO) mod tidy

run-daily-review: build
	./bin/gh -c cfg.toml review

run-weekly-review: build
	./bin/gh -c cfg.toml review weekly

run-monthly-review: build
	./bin/gh -c cfg.toml review monthly

run-debug: build
	./bin/gh review debug "2022-02-01 00:00:00" "2022-02-28 23:59:59"  -c cfg.toml