#include <stdio.h>
#include <stdint.h>

#include "pulpino.h"


#define  AES_CTRL_SHADOWED_OPERATION_MASK           0b11
#define  AES_CTRL_SHADOWED_OPERATION_OFFSET         0
#define  AES_CTRL_SHADOWED_MODE_MASK                0b111111
#define  AES_CTRL_SHADOWED_MODE_OFFSET              2
#define  AES_CTRL_SHADOWED_KEY_LEN_MASK             0b111
#define  AES_CTRL_SHADOWED_KEY_LEN_OFFSET           8
#define  AES_CTRL_SHADOWED_MANUAL_OPERATION_OFFSET  15
#define  AES_STATUS_INPUT_READY_OFFSET              4
#define  AES_STATUS_OUTPUT_VALID_OFFSET             3

#define  AES_KEY_SHARE0_0                           ( 0x1a108000 + 0x04 )
#define  AES_KEY_SHARE1_0                           ( 0x1a108000 + 0x24 )
#define  AES_IV_0                                   ( 0x1a108000 + 0x44 )
#define  AES_DATA_IN_0                              ( 0x1a108000 + 0x54 )
#define  AES_DATA_OUT_0                             ( 0x1a108000 + 0x64 )
#define  AES_CTRL_SHADOWED                          ( 0x1a108000 + 0x74 )
#define  AES_STATUS                                 ( 0x1a108000 + 0x84 )


void wait_input_ready() {
    while (!((REG(AES_STATUS) >> AES_STATUS_INPUT_READY_OFFSET) & 0x1)) {
    }
}

void wait_output_valid() {
    while (!((REG(AES_STATUS) >> AES_STATUS_OUTPUT_VALID_OFFSET) & 0x1)) {
    }
}

int main(int argc, char const* argv[]) {
    int op = 0x01;
    int mode = 0x02;
    int key_len = 0x01;

    uint32_t aes_ctrl_val =
        (op & AES_CTRL_SHADOWED_OPERATION_MASK) << AES_CTRL_SHADOWED_OPERATION_OFFSET |
        (mode & AES_CTRL_SHADOWED_MODE_MASK) << AES_CTRL_SHADOWED_MODE_OFFSET |
        (key_len & AES_CTRL_SHADOWED_KEY_LEN_MASK) << AES_CTRL_SHADOWED_KEY_LEN_OFFSET |
        0x0 << AES_CTRL_SHADOWED_MANUAL_OPERATION_OFFSET;

    int key_share0[8];
    int key_share1[8];
    int iv[4];
    int input_data[4];
    int output_data[4];
    int dec_input_data[4];

    key_share0[0] = 0xa6155d49;
    key_share0[1] = 0xd53d9ea5;
    key_share0[2] = 0xdab9df3a;
    key_share0[3] = 0x36a17e36;
    key_share0[4] = 0x00000000;
    key_share0[5] = 0x00000000;
    key_share0[6] = 0x00000000;
    key_share0[7] = 0x00000000;
    key_share1[0] = 0;
    key_share1[1] = 0;
    key_share1[2] = 0;
    key_share1[3] = 0;
    key_share1[4] = 0;
    key_share1[5] = 0;
    key_share1[6] = 0;
    key_share1[7] = 0;

    iv[0] = 0x497c3320;
    iv[1] = 0xcdcc88ec;
    iv[2] = 0xfb9843f1;
    iv[3] = 0x38440fd8;

    input_data[0] = 0xbb388f1a;
    input_data[1] = 0x34cad614;
    input_data[2] = 0xb9aea5bc;
    input_data[3] = 0x2160cce5;

    // Reference output
    // 0xf3991baf
    // 0xadf4ca0d
    // 0xc3f92c8d
    // 0x19b9a2c7

    REG(AES_CTRL_SHADOWED) = aes_ctrl_val;
    REG(AES_CTRL_SHADOWED) = aes_ctrl_val;

    // Write key - Note: All registers are little-endian.
    for (int j = 0; j < 8; j++) {
        REG(AES_KEY_SHARE0_0 + j * 4) = key_share0[j];
        REG(AES_KEY_SHARE1_0 + j * 4) = key_share1[j];
    }

    // Write IV.
    for (int j = 0; j < 4; j++) {
        REG(AES_IV_0 + j * 4) = iv[j];
    }

    // Write Input Data Block 0.
    wait_input_ready();
    for (int j = 0; j < 4; j++) {
        REG(AES_DATA_IN_0 + j * 4) = input_data[j];
    }

    wait_output_valid();
    for (int j = 0; j < 4; j++) {
        output_data[j] = REG(AES_DATA_OUT_0 + j * 4);
    }



    // Decryption
    op = 0x02;
    mode = 0x02;
    key_len = 0x01;

    aes_ctrl_val =
        (op & AES_CTRL_SHADOWED_OPERATION_MASK) << AES_CTRL_SHADOWED_OPERATION_OFFSET |
        (mode & AES_CTRL_SHADOWED_MODE_MASK) << AES_CTRL_SHADOWED_MODE_OFFSET |
        (key_len & AES_CTRL_SHADOWED_KEY_LEN_MASK) << AES_CTRL_SHADOWED_KEY_LEN_OFFSET |
        0x0 << AES_CTRL_SHADOWED_MANUAL_OPERATION_OFFSET;

    REG(AES_CTRL_SHADOWED) = aes_ctrl_val;
    REG(AES_CTRL_SHADOWED) = aes_ctrl_val;


    // Write key - Note: All registers are little-endian.
    for (int j = 0; j < 8; j++) {
        REG(AES_KEY_SHARE0_0 + j * 4) = key_share0[j];
        REG(AES_KEY_SHARE1_0 + j * 4) = key_share1[j];
    }

    // Write IV.
    for (int j = 0; j < 4; j++) {
        REG(AES_IV_0 + j * 4) = iv[j];
    }

    // Write Input Data Block 0.
    wait_input_ready();
    for (int j = 0; j < 4; j++) {
        REG(AES_DATA_IN_0 + j * 4) = output_data[j];
    }

    wait_output_valid();
    for (int j = 0; j < 4; j++) {
        dec_input_data[j] = REG(AES_DATA_OUT_0 + j * 4);
    }

    // Print result
    for (size_t i = 0; i < 4; i++) {
        printf("%08x\n", dec_input_data[i]);
    }

    for (size_t i = 0; i < 4; i++) {
        if (input_data[i] != dec_input_data[i]) return 1;
    }

    return 0;
}
