---------------------------------------------------------------------------------------------------
--							
-- Dateiname:	Mux.vhd
--
-- Inhalt: 	Verhaltensmodell eines Multiplexers zwei 12-bit-Einganssvektoren
--              und 1 Steuersignal 
--
---------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

---------------------------------------------------------------------------------------------------

ENTITY mux IS

	GENERIC(
   	word_length : integer := 12); 		
   
	PORT(			
   		in_vec0 : IN std_logic_vector(word_length-1 DOWNTO 0);   	-- Eingangsvektor 0
		in_vec1 : IN std_logic_vector(word_length-1 DOWNTO 0);   	-- Eingangsvektor 1
	   	sel_sig : IN std_logic;					 			-- Steuersignal
	   	out_vec : OUT std_logic_vector(word_length-1 DOWNTO 0)); 	-- Ausgangsvektor
		  
END mux;

---------------------------------------------------------------------------------------------------

ARCHITECTURE behavioral OF mux IS

BEGIN

---------------------------------------------------------------------------------------------------

    PROCESS(in_vec1, in_vec0, sel_sig)

    BEGIN
   	IF sel_sig = '1' THEN
				out_vec <= in_vec1;
			ELSE
				out_vec <= in_vec0;
		END IF;        
    END PROCESS;
