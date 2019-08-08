CREATE TABLE [ERP].[UtilidadDetalle] (
    [ID]                            INT             IDENTITY (1, 1) NOT NULL,
    [IdUtilidad]                    INT             NULL,
    [IdTrabajador]                  INT             NULL,
    [DiasTrabajados]                DECIMAL (14, 5) NULL,
    [RemuneracionPercibida]         DECIMAL (14, 5) NULL,
    [UtilidadDiasTrabajados]        DECIMAL (14, 5) NULL,
    [UtilidadRemuneracionPercibida] DECIMAL (14, 5) NULL,
    [Utilidad]                      DECIMAL (14, 5) NULL,
    CONSTRAINT [PK__Utilidad__3214EC27EC92C14A] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK__UtilidadD__IdTra__3DCA962B] FOREIGN KEY ([IdTrabajador]) REFERENCES [ERP].[Trabajador] ([ID]),
    CONSTRAINT [FK__UtilidadD__IdUti__1C69A260] FOREIGN KEY ([IdUtilidad]) REFERENCES [ERP].[Utilidad] ([ID])
);

