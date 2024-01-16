import sys.io.Process;
import haxe.Exception;
import haxe.io.Bytes;
import sys.thread.*;

class Stwiderr {
    static var mode:Bool = false;
    static var text:String;
    static var entry:String = "";
    static var outLines:String;
    static var stream:Bytes;
    static var exitCode:Int;
    
    public static function main():Void {
        if (Sys.args()[0] == "-o") {
            mode = true;
        }
        
		for(i in 0...Sys.args().length){
			if(i == Sys.args().length - 1) entry += Sys.args()[i];
			else entry += Sys.args()[i] + " ";
		}
		
        Sys.println("\x1b[1;41mstwiderr active\x1b[0m");
        //Sys.println(entry);
		var proc:Process = new Process(entry);
        var outLock = new Lock();
        var errLock = new Lock();
        var outStream:String = "";
        var errStream:String = "";
        var outStreamEnd:Bool = false;
        var errStreamEnd:Bool = false;

        Thread.create(() -> {
            while (!outStreamEnd) {
                try {
                    outStream += proc.stdout.readString(1);
                    Sys.print(outStream.charAt(outStream.length - 1));
                } catch (e:Exception) {
                    outStreamEnd = true;
                }
            }
            outLock.release();
        });
        Thread.create(() -> {
            while (!errStreamEnd) {
                try {
                    errStream += proc.stderr.readString(1);
                    Sys.print(errStream.charAt(errStream.length - 1));
                } catch (e:Exception) {
                    errStreamEnd = true;
                }
            }
            errLock.release();
        });

        outLock.wait();
        errLock.wait();

        /*
		if (!mode) {
		    stream = proc.stderr.readAll();
		} else {
		    stream = proc.stdout.readAll();
		}*/
		exitCode = proc.exitCode(true);

        mode ? outLines = outStream : outLines = errStream;

        /*
        var tmp:Array<String> = outLines.split("\n");
        for (line in tmp) {
            Sys.println(line);
        }*/
		
		// Only run if there was a non-zero exit code
		if (exitCode != 0) {
		    text = "Look what Koko tried to do:\n" + //l 30
                   "$ " + entry + "\n...\n";		 //l 7 + entry length
            
            //trace(outLines);
            Sys.println("Posting to Twitter in 2 seconds...");
            Sys.sleep(2);

            while (outLines.length > (243 - entry.length)) {
                decreaseLineLength();
            }
            
            if (outLines.length >= 2) {
                outLines = outLines.substr(0, outLines.length - 1);
                text += outLines;
                //trace("len: " + text.length);
                //Sys.println(text);
                text = StringTools.replace(text, "\"", "“");
                text = StringTools.replace(text, "`", "′");
				// set the app profile in twurl
                Sys.command('twurl set default yourUserName yourApiKey');
                Sys.command('twurl -q -d "status=' + text + '" "/1.1/statuses/update.json"');
                //Sys.println('twurl -q -d "status=' + text + '" "/1.1/statuses/update.json"');
                Sys.println("Posted to Twitter.");
                Sys.exit(exitCode);
            }
		}
    }
    
    static function decreaseLineLength() {
        var tmp:Array<String> = outLines.split("\n");
        tmp.remove(tmp[0]);
        outLines = tmp.join("\n");
    }
}
