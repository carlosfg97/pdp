select distinct CodCatalogo, DesCatalogo from DMATRIZCAMPANA WHERE AnioCampana = '201717'

select distinct * from DTIPOOFERTA where CodTipoOferta like '%2%'
--WHERE CodTipoOferta like '%2%' 


select * 
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
where a.AnioCampana IN ('201804') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216',
'217','218','219','220','221','222','223','224','225','226','227','228')

select * from DMATRIZCAMPANA where AnioCampana = '201805' and DesCatalogo like '%45%'

select * from ARP_OFERTAPERSONALIZADAC01 WHERE CodPais = 'PE' and AnioCampanaVenta = '201802' and TipoPersonalizacion in ('OPT', 'OF')
and CodEbelista = '000000302'
order by CodVenta

select distinct CodVenta from DMATRIZCAMPANA where AnioCampana = '201805' and DesCatalogo like '%35%'

