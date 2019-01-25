ROOTDIR:=.
#HOST_OUT:=$(ROOTDIR)/out/host/
HOST_OUT:=$(ROOTDIR)

hide:=@

.PHONY:
all:
	@mkdir -p bin
	@mkdir -p framework
	@echo "<use prebuilt, so do not make.>"

clean: 
	${hide} rm -rf $(HOST_OUT)/bin
	${hide} rm -rf $(HOST_OUT)/framework
	${hide} rm -rf $(HOST_OUT)/obj

PWD:=$(shell pwd -P)
links:
	ln -fs ../releasetools/add_img_to_target_files.py bin/add_img_to_target_files.py
	ln -fs ../releasetools/blockimgdiff.py bin/blockimgdiff.py
	ln -fs ../releasetools/build_image.py bin/build_image.py
	ln -fs ../releasetools/check_target_files_signatures.py bin/check_target_files_signatures.py
	ln -fs ../releasetools/common.py bin/common.py
	ln -fs ../releasetools/edify_generator.py bin/edify_generator.py
	ln -fs ../releasetools/img_from_target_files.py bin/img_from_target_files.py
	ln -fs ../releasetools/make_recovery_patch.py bin/make_recovery_patch.py
	ln -fs ../releasetools/ota_from_target_files.py bin/ota_from_target_files.py
	ln -fs ../releasetools/rangelib.py bin/rangelib.py
	ln -fs ../releasetools/rootcheck.py bin/rootcheck.py
	ln -fs ../releasetools/sign_target_files_apks.py bin/sign_target_files_apks.py
	ln -fs ../releasetools/sparse_img.py bin/sparse_img.py
	ln -fs ../releasetools/test_common.py bin/test_common.py
	ln -fs ../vendor/prepare_pkg bin/prepare_pkg
	ln -fs ../vendor/gen_update_pkg bin/gen_update_pkg
	ln -fs ../vendor/tools_version.sh bin/tools_version.sh

	ln -fs ../vendor/projects/secure_boot_tools/RSAKeyGen  bin/RSAKeyGen
	ln -fs ../vendor/projects/secure_boot_tools/BscGen     bin/BscGen
	ln -fs ../vendor/projects/secure_boot_tools/VLRSign    bin/VLRSign	
	ln -fs ../vendor/projects/secure_boot_tools/sig_bin.ini  bin/sig_bin.ini
	ln -fs ../vendor/projects/secure_boot_tools/sig_key.ini  bin/sig_key.ini
	ln -fs ../vendor/projects/secure_boot_tools/sig_script.sh  bin/sig_script.sh
#prebuilt
	ln -fs ../prebuilt/bsdiff bin/bsdiff
	ln -fs ../prebuilt/imgdiff bin/imgdiff
	ln -fs ../prebuilt/fs_config bin/fs_config
	ln -fs ../prebuilt/mkbootfs bin/mkbootfs
	ln -fs ../prebuilt/minigzip bin/minigzip
	ln -fs ../prebuilt/simg2img bin/simg2img
	ln -fs ../prebuilt/signapk.jar framework/signapk.jar

install:all links

