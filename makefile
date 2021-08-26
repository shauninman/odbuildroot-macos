.DEFAULT_GOAL := all

IMAGENAME=od-docker
SPARSEIMAGE=$(IMAGENAME).sparseimage
VOLUMEPATH=/Volumes/$(IMAGENAME)
MOUNTFILE=$(VOLUMEPATH)/.mounted
DOCKERPATH=$(VOLUMEPATH)
DOCKERFILE=$(DOCKERPATH)/Dockerfile
WORKSPACE=$(DOCKERPATH)/workspace
BUILDROOT=$(WORKSPACE)/buildroot/.gitignore

$(SPARSEIMAGE):
	hdiutil create -size 20g -type SPARSE -fs "Case-sensitive HFS+" -volname $(IMAGENAME) $(SPARSEIMAGE)

$(MOUNTFILE): $(SPARSEIMAGE)
	hdiutil attach $(SPARSEIMAGE)
	touch $(MOUNTFILE)

$(DOCKERFILE): $(MOUNTFILE)
	if [ ! -f "$(DOCKERFILE)" ]; then unzip -j $(IMAGENAME).zip -d $(VOLUMEPATH) && mkdir -p $(WORKSPACE); fi

$(BUILDROOT): $(DOCKERFILE)
	if [ ! -f "$(BUILDROOT)" ]; then cd $(WORKSPACE) && git clone --recursive https://github.com/OpenDingux/buildroot; fi

all: $(BUILDROOT)
	open $(WORKSPACE)
	cd $(DOCKERPATH) && make shell
	
	