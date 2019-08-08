
-- =============================================
-- Author:		omar rodriguez
-- Create date: 06-08-2019
-- Description:	
-- =============================================
CREATE  PROCEDURE ERP.Spu_insertar_proveedor_excel
	@Documento varchar(30), 
    @IdEmpresa int
AS
BEGIN
DECLARE @IdEntidad int = 0
SELECT @IdEntidad= p.ID  FROM ERP.Entidad  p 
INNER JOIN ERP.EntidadTipoDocumento etd ON p.ID = etd.IdEntidad
WHERE etd.NumeroDocumento = @Documento


IF NOT EXISTS (SELECT p.id FROM ERP.Proveedor p WHERE p.IdEntidad = @IdEntidad AND p.IdEmpresa = @IdEmpresa)
BEGIN
	INSERT ERP.Proveedor
(
    --ID - column value is auto-generated
    IdEntidad,
    IdEmpresa,
    idTipoRelacion,
    FechaRegistro,
    FlagBorrador,
    Flag,
    FechaModificado,
    UsuarioRegistro,
    UsuarioActivo,
    FechaActivacion,
    DiasVencimiento

)
VALUES
(
    -- ID - int
    @IdEntidad , -- IdEntidad - int
    @IdEmpresa, -- IdEmpresa - int
	1,
    getdate(), -- FechaRegistro - datetime
    0, -- FlagBorrador - bit
    N'1', -- Flag - nchar
    getdate(), -- FechaModificado - datetime
    'NTXpro masivo', -- UsuarioRegistro - varchar
    'NTXpro masivo', -- UsuarioActivo - varchar
    getdate(), -- FechaActivacion - datetime
    0 -- DiasVencimiento - int

)
END
END