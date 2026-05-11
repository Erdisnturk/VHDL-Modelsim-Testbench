---------------------------------------------------------------------------------------------------------
--							
-- Dateiname:	Register.vhd
--
-- Inhalt: 	Verhaltensmodell eines word_length breiten Registers, das an 
--			der steigenden Taktflanke beschrieben werden kann
--	
--------------------------------------------------------------------------------------------------------- 

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

--------------------------------------------------------------------------------------------------------- 

ENTITY reg IS

	GENERIC(
   	word_length : integer := 4); 							-- Registerbreite     

	PORT(
		clk : IN std_logic; 										-- Takt
		rst : IN std_logic; 										-- Reset, high active
		en : IN std_logic; 											-- wenn en an einer steigenden Taktflanke
		
																	-- HIGH ist, werden die anliegenden Eingangs-
																	-- daten in das Register �bernommen
		data_in : in std_logic_vector(word_length - 1 DOWNTO 0);  	-- Eingangsdaten
	  	data_out : OUT std_logic_vector(word_length - 1 DOWNTO 0)); -- Ausgangsdaten  
	        
END reg;

---------------------------------------------------------------------------------------------------------
 
ARCHITECTURE behavioral OF reg IS       

BEGIN

PROCESS(clk) -- wird durchlaufen, wenn sich das Taktsignal �ndert

   	BEGIN
		if rst = '1' then
			data_out <= (others => '0');
		elsif en = '1' AND clk'event AND clk = '1' THEN -- an der steigenden Taktflanke von cp werden (wenn en = 1) 
 		                                             -- die anliegenden Daten uebernommen
			data_out <= data_in;		      
		END IF;       
   	END PROCESS; 
   
