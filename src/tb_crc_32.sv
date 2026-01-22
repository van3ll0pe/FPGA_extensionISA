`timescale 1ns/1ps

module tb_crc_32();
    logic        clk;
    logic        rst_n;
    logic [31:0] data_in;
    logic        start;
    logic [31:0] crc_out;
    logic        done;

    // Instanciation du module crc32
    crc_32 dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .start(start),
        .crc_out(crc_out),
        .done(done)
    );

    // Génération de l'horloge (100 MHz)
    always #5 clk = ~clk;

    // Scénario de test
    initial begin
        // Initialisation
        clk = 0;
        rst_n = 0;
        start = 0;
        data_in = 32'h0;

        // Sortie du reset
        #20 rst_n = 1;

        // TEST 1 : Envoyer une valeur
        #10;
        data_in = 32'h12345678;
        start = 1;
        #10;
        start = 0;

        // Attendre que le calcul soit fini
        wait(done);
        $display("Donnee: %h | CRC32: %h", data_in, crc_out);

        // TEST 2 : Une autre valeur
        #20;
        data_in = 32'hABCDE123;
        start = 1;
        #10;
        start = 0;
        
        #100;
        $finish;
    end
endmodule