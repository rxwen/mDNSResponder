LOCAL_PATH := $(call my-dir)

commonSources := \
    mDNSShared/dnssd_clientlib.c  \
    mDNSShared/dnssd_clientstub.c \
    mDNSShared/dnssd_ipc.c

commonLibs := libcutils liblog

commonFlags := \
    -O2 -g \
    -fno-strict-aliasing \
    -D_GNU_SOURCE \
    -DHAVE_IPV6 \
    -DNOT_HAVE_SA_LEN \
    -DPLATFORM_NO_RLIMIT \
	-DUSE_TCP_LOOPBACK \
    -DMDNS_DEBUGMSGS=1 \
    -DMDNS_UDS_SERVERPATH=\"/dev/socket/mdnsd\" \
    -DMDNS_USERNAME=\"root\" \
    -W \
    -Wall \
    -Wextra \
    -Wno-array-bounds \
    -Wno-pointer-sign \
    -Wno-unused \
    -Wno-unused-but-set-variable \
    -Wno-unused-parameter \
    -Werror=implicit-function-declaration \

daemonSources := mDNSCore/mDNS.c            \
                 mDNSCore/DNSDigest.c       \
                 mDNSCore/uDNS.c            \
                 mDNSCore/DNSCommon.c       \
                 mDNSCore/anonymous.c       \
                 mDNSCore/CryptoAlg.c		\
                 mDNSShared/uds_daemon.c    \
                 mDNSShared/mDNSDebug.c     \
                 mDNSShared/dnssd_ipc.c     \
                 mDNSShared/GenLinkedList.c \
                 mDNSShared/PlatformCommon.c \
                 mDNSPosix/PosixDaemon.c    \
                 mDNSPosix/mDNSPosix.c      \
                 mDNSPosix/mDNSUNP.c

daemonIncludes := external/mdnsresponder/mDNSCore  \
                  external/mdnsresponder/mDNSShared \
                  external/mdnsresponder/mDNSPosix

#########################

include $(CLEAR_VARS)
LOCAL_SRC_FILES :=  $(daemonSources)
LOCAL_MODULE := mdnsd
LOCAL_MODULE_TAGS := optional

LOCAL_C_INCLUDES := $(daemonIncludes)

LOCAL_CFLAGS := \
  $(commonFlags) \
  -DTARGET_OS_LINUX \
  -DMDNS_VERSIONSTR_NODTS=1 \
  -DHAVE_LINUX \
  -DUSES_NETLINK \

LOCAL_STATIC_LIBRARIES := $(commonLibs) libc
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_INIT_RC := mdnsd.rc
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES :=  Clients/dns-sd.c \
	Clients/ClientCommon.c
LOCAL_MODULE := dnssd
LOCAL_MODULE_TAGS := optional

LOCAL_C_INCLUDES := $(daemonIncludes)

LOCAL_CFLAGS := \
  $(commonFlags) \
  -DTARGET_OS_LINUX \
  -DMDNS_VERSIONSTR_NODTS=1 \
  -DHAVE_LINUX \
  -DUSES_NETLINK \

LOCAL_SHARED_LIBRARIES := \
	libmdnssd

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(commonSources)
LOCAL_MODULE := libmdnssd
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS := $(commonFlags) -DTARGET_OS_LINUX -DHAVE_LINUX -DUSES_NETLINK
LOCAL_SYSTEM_SHARED_LIBRARIES := libc
LOCAL_SHARED_LIBRARIES := $(commonLibs)
LOCAL_EXPORT_C_INCLUDE_DIRS := external/mdnsresponder/mDNSShared
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(commonSources)
LOCAL_MODULE := libmdnssd
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS := $(commonFlags) -DTARGET_OS_LINUX -DHAVE_LINUX -DUSES_NETLINK
LOCAL_STATIC_LIBRARIES := $(commonLibs)
LOCAL_EXPORT_C_INCLUDE_DIRS := external/mdnsresponder/mDNSShared
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(commonSources)
LOCAL_SRC_FILES_windows := mDNSWindows/DLL/dllmain.c
LOCAL_MODULE := libmdnssd
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS := $(commonFlags)
LOCAL_CFLAGS_windows := \
  -DTARGET_OS_WINDOWS \
  -DWIN32 \
  -DNDEBUG \
  -D_WINDOWS \
  -D_USERDLL \
  -D_MDNS_DEBUGMSGS=0 \
  -D_WIN32_LEAN_AND_MEAN \
  -D_SSIZE_T \
  -DUSE_TCP_LOOPBACK \
  -D_CRT_SECURE_NO_DEPRECATE \
  -D_CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES=1 \
  -DNOT_HAVE_SA_LENGTH \
  -Wno-unknown-pragmas \
  -Wno-sign-compare \
  -Wno-overflow \
  -include stdint.h \
  -include winsock2.h \
  -include ws2ipdef.h \
  -include wincrypt.h \
  -include iphlpapi.h \
  -include netioapi.h \
  -include stdlib.h \
  -include stdio.h

LOCAL_CFLAGS_linux := -DTARGET_OS_LINUX -DHAVE_LINUX -DUSES_NETLINK
LOCAL_CFLAGS_darwin := -DTARGET_OS_MAC
LOCAL_STATIC_LIBRARIES := $(commonLibs)
LOCAL_EXPORT_C_INCLUDE_DIRS := external/mdnsresponder/mDNSShared
LOCAL_C_INCLUDES_windows := external/mdnsresponder/mDNSShared external/mdnsresponder/mDNSWindows
LOCAL_C_INCLUDES_windows += external/mdnsresponder/android/caseMapping
LOCAL_MODULE_HOST_OS := darwin linux windows
include $(BUILD_HOST_STATIC_LIBRARY)

############################
