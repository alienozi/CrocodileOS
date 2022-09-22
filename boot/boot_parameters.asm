bits 16
%define NUMBER_OF_ESSENTIAL_EXTERNAL_MODULES	0
boot_parameter_begin:
boot_parameter_lenght:	dd boot_parameter_end-boot_parameter_begin
kernel_name:db "COS     "		;8 byte zero padded kernel name
kernel_version:db 1,0,0,0		;4 byte kernel version
kernel_load_address:dd 0x100000
number_of_essential_external_modules: dd 0
list_of_essential_external_module_pointer_list:			;this field will be filled(in ram) when
	times NUMBER_OF_ESSENTIAL_EXTERNAL_MODULES dd 0	;the modules are installed
list_of_file_path_of_essential_external_modules:
boot_parameter_end:
