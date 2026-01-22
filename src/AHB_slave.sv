module AHB_slave(   input logic EXTS_HCLK,
                    input logic EXTS_HSEL,
                    output logic EXTS_HREADYIN,
                    input logic[1:0] EXTS_HTRANS,
                    output logic EXTS_HRESP,
                    input logic EXTS_HWRITE,
                    input logic[31:0] EXTS_HADDR,
                    input logic[31:0] EXTS_HWDATA,
                    output logic[31:0] EXTS_HRDATA,
                    input logic EXTS_HRSTN);


logic[31:0] result;
logic is_read;
logic is_write;

logic[31:0] previous_addr;
logic[31:0] previous_data;


    initial begin
        result = 32'hFFFFFFFF;
        previous_addr = 31'h0;
        previous_data = 31'h0;
    end
    

    //Get adress synch value data
    always_ff @(posedge EXTS_HCLK or negedge EXTS_HRSTN) begin
        if (!EXTS_HRSTN) begin      //reset
            previous_addr <= 32'h0;
            previous_data <= 32'h0;
            is_read <= 0;
            is_write <= 0;
        end
        else begin
            previous_addr <= EXTS_HADDR;
            previous_data <= EXTS_HWDATA;
            is_read <= EXTS_HSEL && EXTS_HTRANS[1] && !EXTS_HWRITE;
            is_write <= EXTS_HSEL && EXTS_HTRANS[1] && EXTS_HWRITE;
        end
    end

    //get value
    always_ff @(posedge EXTS_HCLK) begin
           if (is_write) begin
                if (previous_addr == 32'h0E8000000) begin
                    //calculate CRC
                end
            end
    end


    //send value
    always_comb @(posedge EXTS_HCLK) begin
        if (is_read) begin
            if (previous_addr == 32'hE8000000) begin
                EXTS_HRDATA = result;
            end
            else if (previous_addr == 32'hE8000004) begin
                EXTS_HRDATA = 1;
            end
        end
    end
    
    assign EXTS_HREADYIN = 1;
    assign EXTS_HRESP = 0;

endmodule