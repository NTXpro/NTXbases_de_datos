CREATE PROC [ERP].[Usp_Ins_Familia]
@IdFamilia INT OUT,
@IdFamiliaPadre INT,
@IdEmpresa INT,
@Nombre VARCHAR(200)
AS
BEGIN

		INSERT INTO ERP.Familia(
								IdFamiliaPadre,
								IdEmpresa,
								Nombre,
								FlagSistema) 
								VALUES (
								CASE WHEN @IdFamiliaPadre = 0 THEN NULL ELSE @IdFamiliaPadre END,
								@IdEmpresa,
								@Nombre,
								CAST(0 AS BIT))

		SET @IdFamilia = SCOPE_IDENTITY()

END
