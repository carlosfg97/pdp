select * from ARP_OFERTAPERSONALIZADAC01 WHERE CodPais = 'PE' and AnioCampanaVenta = '201802' and TipoPersonalizacion in ('OPT', 'OF')
and CodEbelista = '000000302'
order by CodVenta

select * from DWH_ANALITICO.DBO.DWH_FVTAPROEBECAM WHERE CODPAIS = 'PE' AND ANIOCAMPANA = '201802' AND cODvENTA = '96565'

select * from DWH_ANALITICO.DBO.DWH_DTIPOOFERTA  WHERE CODPAIS = 'PE' 


select top (10000) C.CodTipoOferta from ARP_OFERTAPERSONALIZADAC01 a
inner join DWH_ANALITICO.DBO.DWH_FVTAPROEBECAM b on a.CodVenta = b.CodVenta and a.AnioCampanaVenta = b.AnioCampana and a.CodPais = b.CodPais
inner join DWH_ANALITICO.DBO.DWH_DTIPOOFERTA  c on b.PKTipoOferta = C.PKTipoOferta
WHERE a.CodPais = 'PE' and AnioCampanaVenta = '201802' and TipoPersonalizacion in ('OF')
order by a.CodVenta
-- UN COD VENTA que se creo para una personalizacion de OF, luego se busca en la facturacion y vemos qe estaba registrado con el 
-- codtipooferta de la palanca digitl OPT

select top (1000) DesCatalogo, CodTipoOferta, c.DesTipoOferta from ARP_OFERTAPERSONALIZADAC01 a
inner join DWH_ANALITICO.DBO.DWH_FVTAPROEBECAM b on a.CodVenta = b.CodVenta and a.AnioCampanaVenta = b.AnioCampana and a.CodPais = b.CodPais
inner join DWH_ANALITICO.DBO.DWH_DTIPOOFERTA  c on b.PKTipoOferta = C.PKTipoOferta
INNER JOIN DWH_ANALITICO.DBO.DWH_DMATRIZCAMPANA d ON b.AnioCampana = d.AnioCampana and b.CodVenta = d.CodVenta
WHERE a.CodPais = 'PE' and AnioCampanaVenta = '201802' and TipoPersonalizacion in ('OF')
order by a.CodVenta

SELECT * from 

--cuando busco tipopersonalizacion of, aparecen unos destipooferta opt. y al reves
--

select * from DMATRIZCAMPANA WHERE AnioCampana = '201805' AND DesTipoCatalogo LIKE '%ESIKA%'
order by PaginaCatalogo
