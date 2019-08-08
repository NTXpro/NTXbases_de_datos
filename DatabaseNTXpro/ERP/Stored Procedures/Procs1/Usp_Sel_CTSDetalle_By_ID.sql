
create PROC [ERP].[Usp_Sel_CTSDetalle_By_ID]
@ID int
AS
BEGIN
	SELECT ID
		  ,IdCTS
		  ,IdDatoLaboral
		  ,Sueldo
		  ,AsignacionFamiliar
		  ,Bonificacion
		  ,HE25
		  ,HE35
		  ,HE100
		  ,Comision
		  ,Remuneracion
		  ,Mes
		  ,ValorMes
		  ,ImporteMes
		  ,Dias
		  ,ValorDia
		  ,ImporteDia
		  ,TotalCTS
  FROM ERP.CTSDetalle
  WHERE ID = @ID
END
