module crc_32 (
    input  logic        clk,
    input  logic        rst_n,    // Reset actif bas
    input  logic [31:0] data_in,  // Le mot de 32 bits à traiter
    input  logic        start,    // Signal pour lancer le calcul
    output logic [31:0] crc_out,  // Le résultat final inversé
    output logic        done      // Indique que le résultat est prêt
);

    // Constante polynomiale standard IEEE 802.3 (0x04C11DB7)
    localparam logic [31:0] POLYNOMIAL = 32'h04C11DB7;

    logic [31:0] crc_state;

    function [31:0] compute_crc32;
      input [31:0] data;
      logic [31:0] temp_v;
      logic [31:0] data_reversed;
      begin
          // 1. Inverser l'ordre des bits de l'entrée (Reflect data)
          for (int j = 0; j < 32; j++) data_reversed[j] = data[31-j];

          // 2. XOR initial
          temp_v = data_reversed ^ 32'hFFFFFFFF;

          // 3. Boucle de réduction
          for (int i = 0; i < 32; i++) begin
              if (temp_v[31])
                  temp_v = (temp_v << 1) ^ 32'h04C11DB7;
              else
                  temp_v = (temp_v << 1);
          end

          // 4. Inverser l'ordre des bits du résultat (Reflect output)
          for (int k = 0; k < 32; k++) compute_crc32[k] = temp_v[31-k];
      end
  endfunction

    // --- Logique séquentielle ---
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            crc_state <= 32'h0;
            done      <= 1'b0;
        end else if (start) begin
            // On exécute le calcul et on stocke le résultat
            crc_state <= compute_crc32(data_in);
            done      <= 1'b1;
        end else begin
            done      <= 1'b0;
        end
    end

    // Étape 3 : XOR final (Inversion de tous les bits)
    assign crc_out = ~crc_state;

endmodule