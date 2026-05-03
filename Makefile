# Define el objetivo: iPhone usando clang y SDK de iOS 14
TARGET := iphone:clang:latest:14.0
# Arquitectura para dispositivos modernos (64 bits)
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

# Nombre del proyecto
TWEAK_NAME = ResetGuest

# Archivos a compilar (tu Archivo 1)
ResetGuest_FILES = Tweak.x

# Frameworks necesarios para Keychain y manejo de archivos
ResetGuest_FRAMEWORKS = UIKit Foundation Security

include $(THEOS)/makefiles/tweak.mk
