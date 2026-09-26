`timescale 1ns/100ps
module fifo_test #(DEPTH,DATA_WIDTH)(
    fifo_interface fif
);
logic [DATA_WIDTH-1:0] expected_fifo[$];
logic [DATA_WIDTH-1:0] temp;

//clocking at positive edge tasl 
task tick;
@(posedge fif.clk);
endtask

//reset task 
task reset_fifo();
fif.w_en=0;
fif.r_en=0;
fif.data_in=0;

expected_fifo.delete();

wait(fif.rst_n); //wait til the rst reaches 1 
repeat(3)
    tick();
endtask


//---WRITE TASK--//
task write_fifo(input [DATA_WIDTH-1:0] data);
if(!fif.full)begin 
    $display("writing=%0d",data);
     expected_fifo.push_back(data);
    fif.data_in=data;
    fif.w_en=1;

    tick();
       
    fif.w_en=0;
    tick();
end
else begin 
    $display("FIFO is full");
end

endtask

//----READ TASK-----//
task read_fifo();
if(!fif.empty)begin 
    fif.r_en=1;
    tick();
    #1;
    $display("fifo output=%0d",fif.data_out);
    if(expected_fifo.size()>0)
        temp=expected_fifo.pop_front();
    else begin 
        $display("ERROR: Scoreboard empty!");
    return;
    end
    if(fif.data_out==temp)
        $display("PASS read=%0d",temp);
    else
        $display("fail expected=%0d got=%0d",temp,fif.data_out);
    fif.r_en=0;
    tick();

end
else 
    $display("FIFO empty");

endtask

//1.--------------------------------CLEAR FIFO TEST------------------------------//
task clear_fifo_test();


logic [DATA_WIDTH-1:0] data;
 
 $display("CLEAR FIFO TEST");
 expected_fifo.delete();

 //write 0s in fifo
 for(int i=0;i<DEPTH;i++)begin
    write_fifo('0);
  end
  //read everything back from fifo 
  for(int i=0;i<DEPTH;i++)begin 
    read_fifo();
  end
  if(fif.empty)
    $display("Clear fifo test passed");
else
$display("clar fifo test failed");
endtask

//2.-------------------------------------DATA=ADDRESS TEST----------------------------------------//
task data_index_test();

$display("data=index test");

expected_fifo.delete();

for(int i=0;i<DEPTH;i++) begin 
    write_fifo(i);
end
repeat(2)
    tick();
for(int i=0;i<DEPTH;i++)
    read_fifo();

$display("data=index test complete");
endtask

//3.-----------------------------------------READ AFTER WRITE TEST--------------------------------------//
task read_after_write();
logic [DATA_WIDTH-1:0] rand_data;
repeat(25)
begin 
    rand_data=$urandom;
    write_fifo(rand_data);
    read_fifo();
end
$display("READ AFTER WRITE TEST COMPLETE");
endtask

//4.------------------------------------------RANDOM TEST----------------------------------------//
task random_test();
    logic [DATA_WIDTH-1:0] rand_data;
    
    $display("RANDOM TEST START");
    expected_fifo.delete();
    
    repeat(50) begin          // 50 pairs = 100 operations
        // Step 1: always write first
        rand_data = $urandom;
        write_fifo(rand_data);
        
        // Step 2: always read after
        read_fifo();
    end
    
    // drain anything left
    while(!fif.empty)
        read_fifo();
    
    $display("RANDOM TEST COMPLETE");
endtask

initial begin 
    reset_fifo();
    clear_fifo_test();

    reset_fifo();
    data_index_test();

    reset_fifo();
    read_after_write();

    reset_fifo();
    random_test();
    #50;
    $finish;
end
endmodule
