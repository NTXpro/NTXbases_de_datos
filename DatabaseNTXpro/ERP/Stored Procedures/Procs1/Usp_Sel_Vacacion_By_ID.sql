
CREATE PROC [ERP].[Usp_Sel_Vacacion_By_ID]
@ID INT
AS
BEGIN
	SELECT V.ID
		  ,V.IdDatoLaboral
		  ,V.IdEmpresa
		  ,V.IdPeriodo
		  ,V.FechaInicio
		  ,V.FechaFin
		  ,V.Corresponde
		  ,V.HNormal
		  ,V.SueldoMinimo
		  ,V.PorcentajeAFamiliar
		  ,V.AFamiliar
		  ,V.HE25
		  ,V.HE35
		  ,V.HE100
		  ,V.Bonificacion
		  ,V.Comision
		  ,V.Promedio
		  ,V.ValorDia
		  ,V.Dias
		  ,V.Total
		  ,V.Flag
		  ,V.UsuarioRegistro
		  ,V.FechaRegistro
		  ,A.Nombre Anio
		  ,M.Valor Mes
		  ,E.Nombre NombreTrabajador
		  ,DL.FechaInicio FechaInicioDatoLaboral
  FROM ERP.Vacacion V
  INNER JOIN ERP.DatoLaboral DL ON DL.ID = V.IdDatoLaboral
  INNER JOIN ERP.Trabajador T ON T.ID = DL.IdTrabajador
  INNER JOIN ERP.Entidad E ON E.ID = T.IdEntidad
  LEFT JOIN ERP.Periodo P ON P.ID = V.IdPeriodo
  LEFT JOIN Maestro.Anio A ON A.ID = P.IdAnio
  LEFT JOIN Maestro.Mes M ON M.ID = P.IdMes
  WHERE V.ID = @ID
END
