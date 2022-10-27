#![no_std]
#![no_main]

extern "C" {
    pub fn printf(fmt: *const u8) -> u8;
}

#[no_mangle]
unsafe extern "C" fn main(_argc: isize, _argv: *const *const u8) -> isize {
    printf(b"HELLO WORLD" as *const u8);
    0
}

#[panic_handler]
fn my_panic(_info: &core::panic::PanicInfo) -> ! {
    loop {}
}
