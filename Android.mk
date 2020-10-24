LOCAL_PATH := $(call my-dir)

commonSources := \
	mDNSCore/anonymous.c       \
	mDNSCore/CryptoAlg.c		\
	mDNSCore/DNSCommon.c       \
	mDNSCore/DNSDigest.c       \
	mDNSCore/mDNS.c            \
	mDNSCore/uDNS.c            \
	mDNSShared/mDNSDebug.c     \
	mDNSShared/dnssd_ipc.c     \
	mDNSShared/GenLinkedList.c \
	mDNSShared/PlatformCommon.c \
    mDNSShared/dnssd_clientlib.c  \
    mDNSShared/dnssd_clientstub.c \
	mDNSPosix/mDNSPosix.c      \
	Clients/ClientCommon.c \
	mDNSPosix/mDNSUNP.c

commonLibs := libcutils liblog

commonFlags := \
    -O2 -g \
    -fno-strict-aliasing \
    -D_GNU_SOURCE \
    -DHAVE_IPV6 \
    -D__ANDROID__ \
    -DNOT_HAVE_SA_LEN \
    -DPLATFORM_NO_RLIMIT \
	-DUSE_TCP_LOOPBACK \
    -DMDNS_DEBUGMSGS=0 \
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

daemonSources := \
	mDNSShared/uds_daemon.c    \
	mDNSPosix/PosixDaemon.c

daemonIncludes := \
	external/mdnsresponder/mDNSCore  \
    external/mdnsresponder/mDNSShared \
	external/mdnsresponder/mDNSPosix

#########################

include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(commonSources)
LOCAL_MODULE := libmdnssd
LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES := $(daemonIncludes)
LOCAL_CFLAGS := $(commonFlags) -DTARGET_OS_LINUX -DHAVE_LINUX -DUSES_NETLINK
# LOCAL_SYSTEM_SHARED_LIBRARIES := libc
LOCAL_SHARED_LIBRARIES := $(commonLibs)
LOCAL_COPY_HEADERS := mDNSShared/dns_sd.h

include $(BUILD_SHARED_LIBRARY)

############################

include $(CLEAR_VARS)
LOCAL_SRC_FILES :=  $(daemonSources)
LOCAL_MODULE := mdnsd
LOCAL_MODULE_TAGS := optional

LOCAL_C_INCLUDES := $(daemonIncludes)

LOCAL_CFLAGS := \
  $(commonFlags) \
  -DTARGET_OS_LINUX \
  -DHAVE_LINUX \
  -DUSES_NETLINK \

LOCAL_SHARED_LIBRARIES := libmdnssd $(commonLibs)
# LOCAL_FORCE_STATIC_EXECUTABLE := true
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
LOCAL_SRC_FILES := Clients/dns-sd.c
LOCAL_MODULE := dnssd
LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES += external/mdnsresponder/mDNSShared
LOCAL_CFLAGS := $(commonFlags) -DTARGET_OS_LINUX -DHAVE_LINUX -DUSES_NETLINK
# LOCAL_SYSTEM_SHARED_LIBRARIES := libc
LOCAL_SHARED_LIBRARIES := libmdnssd libcutils liblog
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := mDNSPosix/NetMonitor.c
LOCAL_MODULE := netmonitor
LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES += external/mdnsresponder/mDNSShared
LOCAL_CFLAGS := $(commonFlags) -DTARGET_OS_LINUX -DHAVE_LINUX -DUSES_NETLINK
# LOCAL_SYSTEM_SHARED_LIBRARIES := libc
LOCAL_SHARED_LIBRARIES := libmdnssd libcutils liblog
include $(BUILD_EXECUTABLE)

############################
# This builds an mDns that is embeddable within GmsCore for the nearby connections API
