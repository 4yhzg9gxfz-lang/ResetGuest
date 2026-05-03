#import <Foundation/Foundation.h>
#import <Security/Security.h>

// El constructor se ejecuta apenas la dylib se inyecta en el juego
%ctor {
    // Añadimos un pequeño retraso de 1.5 segundos para asegurar que el sistema de archivos de la app esté listo
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // --- 1. LIMPIEZA DEL KEYCHAIN ---
        // Borra los datos persistentes que el juego guarda en el llavero de iOS
        NSArray *secClasses = @[
            (__bridge id)kSecClassGenericPassword,
            (__bridge id)kSecClassInternetPassword,
            (__bridge id)kSecClassCertificate,
            (__bridge id)kSecClassKey,
            (__bridge id)kSecClassIdentity
        ];

        for (id secClass in secClasses) {
            NSDictionary *query = @{(__bridge id)kSecClass: secClass};
            SecItemDelete((__bridge CFDictionaryRef)query);
        }

        // --- 2. LIMPIEZA DE ARCHIVOS LOCALES ---
        // Borra la carpeta donde se almacena el ID de invitado (Guest ID)
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        // Ruta típica de identificación en Free Fire
        NSString *msdkPath = [docPath stringByAppendingPathComponent:@"com.garena.msdk"];
        
        if ([fm fileExistsAtPath:msdkPath]) {
            NSError *error;
            [fm removeItemAtPath:msdkPath error:&error];
        }
        
        // También borramos el archivo device_id si existe
        NSString *deviceIdPath = [docPath stringByAppendingPathComponent:@"device_id.json"];
        if ([fm fileExistsAtPath:deviceIdPath]) {
            [fm removeItemAtPath:deviceIdPath error:nil];
        }
    });
}
