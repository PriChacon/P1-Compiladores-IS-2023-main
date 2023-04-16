package src;

import org.w3c.dom.Node;

import java_cup.runtime.Symbol;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.Reader;

public class App {
    public void analizar(String archivoFuente) {
        try {
            Reader reader = new BufferedReader(new FileReader(archivoFuente));
            //reader.read();
            Analizador analizador = new Analizador(reader);
            int i = 0;
            Symbol token;
            while(true){
                token = analizador.next_token();
                if(token.sym != 0)
                    System.out.println("I: " + i + "\tToken: " + token.sym + "\tvalor: "+analizador.yytext());
                else{
                    System.out.println("Lexemas encontrados: " + i);
                    return;
                }
                i++;
            }
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }

    public void parsear(String archivoFuente) {
        try {
            Reader reader = new BufferedReader(new FileReader(archivoFuente));
            //reader.read();
            Analizador analizador = new Analizador(reader);
            parser parse_obj = new parser(analizador);

            parse_obj.parse();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    

    
}
    