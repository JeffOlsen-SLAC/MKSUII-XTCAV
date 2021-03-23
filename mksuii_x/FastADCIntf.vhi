
-- VHDL Instantiation Created from source file FastADCIntf.vhd -- 09:09:53 06/24/2013
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT FastADCIntf
	PORT(
		Clock : IN std_logic;
		Reset : IN std_logic;
		Clk1HzEn : IN std_logic;
		Lnk_Addr : IN std_logic_vector(15 downto 0);
		Lnk_Wr : IN std_logic;
		Lnk_DataIn : IN std_logic_vector(15 downto 0);
		Lnk_WFMRd : IN std_logic;
		ArmWFM : IN std_logic;
		ArmAve : IN std_logic;
		Trigger : IN std_logic;
		FADC_FRAME_CLK_P : IN std_logic;
		FADC_FRAME_CLK_N : IN std_logic;
		FADC_DATA_CLK_P : IN std_logic;
		FADC_DATA_CLK_N : IN std_logic;
		BEAM_V_P : IN std_logic;
		BEAM_V_N : IN std_logic;
		BEAM_I_P : IN std_logic;
		BEAM_I_N : IN std_logic;
		FWD_PWR_P : IN std_logic;
		FWD_PWR_N : IN std_logic;
		REFL_PWR_P : IN std_logic;
		REFL_PWR_N : IN std_logic;          
		Reg_DataOut : OUT std_logic_vector(15 downto 0);
		Status : OUT std_logic_vector(15 downto 0);
		WFMArmed : OUT std_logic;
		AveArmed : OUT std_logic;
		Beam_V_Average : OUT std_logic_vector(15 downto 0);
		Beam_I_Average : OUT std_logic_vector(15 downto 0);
		FWD_PWR_Average : OUT std_logic_vector(15 downto 0);
		REFL_PWR_Average : OUT std_logic_vector(15 downto 0);
		WFM_Avail : OUT std_logic;
		BeamILow : OUT std_logic;
		FADC_CLK_P : OUT std_logic;
		FADC_CLK_N : OUT std_logic;
		DataclkLocked : OUT std_logic
		);
	END COMPONENT;

	Inst_FastADCIntf: FastADCIntf PORT MAP(
		Clock => ,
		Reset => ,
		Clk1HzEn => ,
		Lnk_Addr => ,
		Lnk_Wr => ,
		Lnk_DataIn => ,
		Lnk_WFMRd => ,
		Reg_DataOut => ,
		Status => ,
		ArmWFM => ,
		ArmAve => ,
		WFMArmed => ,
		AveArmed => ,
		Beam_V_Average => ,
		Beam_I_Average => ,
		FWD_PWR_Average => ,
		REFL_PWR_Average => ,
		Trigger => ,
		WFM_Avail => ,
		BeamILow => ,
		FADC_CLK_P => ,
		FADC_CLK_N => ,
		FADC_FRAME_CLK_P => ,
		FADC_FRAME_CLK_N => ,
		FADC_DATA_CLK_P => ,
		FADC_DATA_CLK_N => ,
		BEAM_V_P => ,
		BEAM_V_N => ,
		BEAM_I_P => ,
		BEAM_I_N => ,
		FWD_PWR_P => ,
		FWD_PWR_N => ,
		REFL_PWR_P => ,
		REFL_PWR_N => ,
		DataclkLocked => 
	);


