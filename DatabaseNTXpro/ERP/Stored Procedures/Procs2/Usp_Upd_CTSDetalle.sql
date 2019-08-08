
create PROC [ERP].[Usp_Upd_CTSDetalle]
@ID INT,
@Sueldo DECIMAL(14,5),
@AsignacionFamiliar DECIMAL(14,5),
@Bonificacion DECIMAL(14,5),
@HE25 DECIMAL(14,5),
@HE35 DECIMAL(14,5),
@HE100 DECIMAL(14,5),
@Comision DECIMAL(14,5),
@Remuneracion DECIMAL(14,5),
@Mes DECIMAL(14,5),
@ValorMes DECIMAL(14,5),
@ImporteMes DECIMAL(14,5),
@Dias DECIMAL(14,5),
@ValorDia DECIMAL(14,5),
@ImporteDia DECIMAL(14,5),
@TotalCTS DECIMAL(14,5)
AS
BEGIN
	UPDATE ERP.CTSDetalle SET
	   Sueldo = @Sueldo 
      ,AsignacionFamiliar = @AsignacionFamiliar
      ,Bonificacion = @Bonificacion
      ,HE25 = @HE25
      ,HE35 = @HE35
      ,HE100 = @HE100
      ,Comision = @Comision
      ,Remuneracion = @Remuneracion
      ,Mes = @Mes
      ,ValorMes = @ValorMes
      ,ImporteMes = @ImporteMes
      ,Dias = @Dias
      ,ValorDia = @ValorDia
      ,ImporteDia = @ImporteDia
      ,TotalCTS = @TotalCTS
	  WHERE ID = @ID
END
