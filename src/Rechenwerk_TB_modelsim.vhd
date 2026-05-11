---------------------------------------------------------------------------------------------
-- Dateiname: Rechenwerk_TB_modelsim.vhd
-- Inhalt: Testbench for data_path_struct
---------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Rechenwerk_TB IS
END Rechenwerk_TB;

ARCHITECTURE behavior OF Rechenwerk_TB IS

    constant clk_period : time := 10 ns;

    signal clk            : std_logic := '0';
    signal rst            : std_logic := '1';

    signal mux_sel_sig    : std_logic := '0';
    signal R1_en          : std_logic := '0';
    signal R2_en          : std_logic := '0';
    signal instruction    : std_logic_vector(3 downto 0) := (others => '0');
    signal instruction_en : std_logic := '0';
    signal mux_R2_data_in : std_logic_vector(3 downto 0) := (others => '0');

    signal status_out     : std_logic_vector(2 downto 0);
    signal alu_res        : std_logic_vector(3 downto 0);
    signal alu_res_rdy    : std_logic;

    type program_array is array (0 to 8) of std_logic_vector(7 downto 0);

    constant program : program_array := (
        0 => "10001100", -- LD1 #C
        1 => "10011000", -- LD2 #8
        2 => "00000000", -- ADD
        3 => "10010100", -- LD2 #4
        4 => "00010000", -- SUB
        5 => "00010000", -- SUB
        6 => "10001100", -- LD1 #C
        7 => "10011000", -- LD2 #8
        8 => "10100010"  -- JMP #2
    );

BEGIN

    -------------------------------------------------------------------------
    -- 100 MHz clock
    -------------------------------------------------------------------------
    clk <= not clk after clk_period / 2;

    -------------------------------------------------------------------------
    -- Reset active high for first 100 ns
    -------------------------------------------------------------------------
    reset_process : process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait;
    end process;

    -------------------------------------------------------------------------
    -- Unit Under Test
    -------------------------------------------------------------------------
    uut : entity work.data_path_struct
        port map(
            clk            => clk,
            rst            => rst,
            mux_sel_sig    => mux_sel_sig,
            R1_en          => R1_en,
            R2_en          => R2_en,
            instruction    => instruction,
            instruction_en => instruction_en,
            mux_R2_data_in => mux_R2_data_in,
            status_out     => status_out,
            alu_res        => alu_res,
            alu_res_rdy    => alu_res_rdy
        );

    -------------------------------------------------------------------------
    -- Stimulus process
    -------------------------------------------------------------------------
    stimulus_process : process

        variable pc    : integer range 0 to 8 := 0;
        variable instr : std_logic_vector(7 downto 0);
        variable count : integer := 0;

    begin

        R1_en          <= '0';
        R2_en          <= '0';
        instruction_en <= '0';
        mux_sel_sig    <= '0';
        instruction    <= (others => '0');
        mux_R2_data_in <= (others => '0');

        wait until rst = '0';
        wait until rising_edge(clk);

        while count < 20 loop

            instr := program(pc);

            instruction    <= instr(7 downto 4);
            mux_R2_data_in <= instr(3 downto 0);

            R1_en          <= '0';
            R2_en          <= '0';
            instruction_en <= '0';
            mux_sel_sig    <= '0';

            case instr(7 downto 4) is

                when "1000" =>        -- LD1
                    mux_sel_sig <= '1';
                    R1_en       <= '1';

                when "1001" =>        -- LD2
                    R2_en <= '1';

                when "1010" =>        -- JMP
                    pc := to_integer(unsigned(instr(3 downto 0)));
                    wait until rising_edge(clk);
                    count := count + 1;
                    next;

                when others =>        -- ALU operation
                    mux_sel_sig    <= '0';
                    R1_en          <= '1';
                    instruction_en <= '1';

            end case;

            wait until rising_edge(clk);

            if pc < 8 then
                pc := pc + 1;
            else
                pc := 0;
            end if;

            count := count + 1;

        end loop;

        R1_en          <= '0';
        R2_en          <= '0';
        instruction_en <= '0';
        mux_sel_sig    <= '0';

        wait;

    end process;

END behavior;
