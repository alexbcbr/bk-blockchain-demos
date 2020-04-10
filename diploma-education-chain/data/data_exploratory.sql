DROP TABLE leito
CREATE TABLE leito
CREATE INDEX ON leito (unidade)
 
INSERT INTO leito
<< {
    'unidade' : '10',
    'hospital' : 'Hospital Geral',
    'paciente' : 'Maria Albuquerque',
    'atendimento' : {
        'AtendimentoPrimario' : { 'Enfermeira': '' },
        'AtendimentoSecundario' : []
    }
} >>
 
select * from history(leito)

UPDATE leito AS r
SET r.atendimento. = 'Vancouver'
WHERE r.unidade = '10'
 
SELECT h.unidade, h.hospital, h.paciente
FROM history(leito) AS h
WHERE h.metadata.id = '3mDCKOS7i1SEgesOL5Z8ec'