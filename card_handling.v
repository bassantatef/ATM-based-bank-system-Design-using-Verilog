module card_handling #(parameter    C_WIDTH   = 6,
                                    P_WIDTH   = 16,
                                    B_WIDTH   = 20,
                                    USERS_NUM = 10)
(
    input wire                  clk,
    input wire                  rst,
    input wire [C_WIDTH-1:0]    card_number,
    input wire                  card_in,
    input wire                  card_out,
    input wire                  operation_done,

    input wire [B_WIDTH-1:0]    updated_balance,
    
    output reg [P_WIDTH-1:0]    password,
    output reg [B_WIDTH-1:0]    balance,
    output reg                  pass_en    // enable flag to FSM to transit from idle state

);

reg [P_WIDTH-1:0] password_memory [0:USERS_NUM-1] ;
reg [B_WIDTH-1:0] balance_memory  [0:USERS_NUM-1] ;


always @(posedge clk or negedge rst) 
begin
    if (!rst) 
    begin
        // initialize the memory from a text file
        //$readmemb("password_memory.txt", password_memory) ;
        //$readmemb("balance_memory.txt" , balance_memory ) ;

        password_memory[0] = 'b0011_0011_0111_0000 ;
        password_memory[1] = 'b0011_0101_0000_0110 ;
        password_memory[2] = 'b0100_0000_0111_0110 ;
        password_memory[3] = 'b0011_0011_0111_0000 ;
        password_memory[4] = 'b0101_0010_1001_1000 ;
        password_memory[5] = 'b0110_0110_0011_1001 ;
        password_memory[6] = 'b0010_0010_1000_0100 ;
        password_memory[7] = 'b1001_0001_0010_0101 ;
        password_memory[8] = 'b1000_0110_0101_0111 ;
        password_memory[9] = 'b0101_0111_1001_0001 ;

        balance_memory[0]  = 'd2200   ;
        balance_memory[1]  = 'd50000  ;
        balance_memory[2]  = 'd10000  ;
        balance_memory[3]  = 'd200000 ;
        balance_memory[4]  = 'd100000 ;
        balance_memory[5]  = 'd4000   ;
        balance_memory[6]  = 'd20000  ;
        balance_memory[7]  = 'd25000  ;
        balance_memory[8]  = 'd40000  ;
        balance_memory[9]  = 'd15000  ;

        password <= 'b0 ;
        balance  <= 'b0 ;
    end 
    else 
    begin
        if(card_number < USERS_NUM)
        begin
            if(card_in)
            begin
                password <= password_memory[card_number] ;
                balance  <= balance_memory[card_number]  ;
            end
            if(card_out || operation_done)
            begin
                balance_memory[card_number] <= updated_balance ;
            end
        end
        else
        begin
            password <= 'b0 ;
            balance  <= 'b0 ;
        end
    end
end

always @(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        pass_en <= 1'b0 ;
    end
    else if(card_number < USERS_NUM)
    begin
        pass_en <= card_in ;
    end
    else begin
        
        
    end
end


endmodule