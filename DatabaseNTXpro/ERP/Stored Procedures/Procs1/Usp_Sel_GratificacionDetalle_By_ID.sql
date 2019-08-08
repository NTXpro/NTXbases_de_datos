
CREATE PROC ERP.Usp_Sel_GratificacionDetalle_By_ID
@ID int
AS
BEGIN
	SELECT ID
		  ,IdGratificacion
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
		  ,TotalGratificacion
  FROM ERP.GratificacionDetalle
  WHERE ID = @ID
END
