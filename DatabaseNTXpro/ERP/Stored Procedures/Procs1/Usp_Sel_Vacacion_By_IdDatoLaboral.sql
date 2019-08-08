
CREATE PROC [ERP].[Usp_Sel_Vacacion_By_IdDatoLaboral]
@IdDatoLaboral INT
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
  FROM ERP.Vacacion V
  LEFT JOIN ERP.Periodo P ON P.ID = V.IdPeriodo
  LEFT JOIN Maestro.Anio A ON A.ID = P.IdAnio
  LEFT JOIN Maestro.Mes M ON M.ID = P.IdMes
  WHERE IdDatoLaboral = @IdDatoLaboral
END
