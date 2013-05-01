Coding Challenge
================    
This coding challenge is oriented to get some contact with the apertium system refer to the proposed idea:
"Interface for creating tagged corpora"

Step to follow:
* Install Apertium
* Install a language pair of your choice.
* Train a tagger in an unsupervised manner for one of the languages in your pair.
* For one of the languages in the pair, create a manually tagged corpus for this story in a language of your choice. Make sure it already has a morphological analyser!
* Now train the tagger in a supervised manner from the corpus you just tagged. 

Install Apertium
- - -
to be able to use apertium as developer you should install the minimum instalation from SVN following this link

[minimum instalation](http://wiki.apertium.org/wiki/Minimal_installation_from_SVN)

you should install lttoolbox and apertium from the svn following the rules on the wiki described
Also you need the apertium-tagger-training-tools

    $> svn checkout https://apertium.svn.sourceforge.net/svnroot/apertium/trunk/apertium-tagger-training-tools/

Install a language pair of your choice.
- - -
On this case I choiced the en-es. To download it you can use directly from the svn repository using this command:

    svn checkout https://apertium.svn.sourceforge.net/svnroot/apertium/trunk/apertium-en-es/

Once you get the repository, you just have to generate the .bin files and the .deps folder using:

    $> sh ./autogen.sh

    $> make

Train a tagger in an unsupervised manner for one of the languages in your pair.
- - -
Once you autogen the language pair you have a folder es-tagged-data and the corpus file describes on the wiki guide:

[Unsupervised tagger training](http://wiki.apertium.org/wiki/Unsupervised_tagger_training)

You should rename es-tagger-data/es.corpus.txt to es-tagger-data/es.crp.txt to run the next comand and also rewrite the words :
    
    Mar to mar

    VI to 6

And then you can launch the command:

    $> make -f en-es-unsupervised.make

Once this finish you'll have the en-es.prob file that you expected have, so we are done :)

For one of the languages in the pair, create a manually tagged corpus for this story in a language of your choice. Make sure it already has a morphological analyser!
- - -
As I can see the pair language I choose has the morpholigical analyser (en-es.automorf.bin file), so I can create a tagged manually from the history in the file *history.txt* (you can check it on the folder es-tagger-data)

To have the tagged corpus just have to use the lt-proc program and save the output in a file:

    $> cat history.txt | lt-proc ../es-en.automorf.bin > history.txt.tagged

To tag manually the file you have to choose the correct word for every ambiguate word (you can check the *history.txt.tagged* file)

Now train the tagger in a supervised manner from the corpus you just tagged. 
- - -
Once I have the earlier s
teps done, I'm able to tag supervisedly the corpus I tagged and disambeguated manually with the following instructions:
    
    $> cd es-tagger-data

    $> apertium-trigrams-langmodel -t -i history.txt > spanish.lm

    $> apertium-tagger-gen-crp-file history.txt ../es-en.automorf.bin > lang.crp

    $> apertium-tagger-gen-dic-file ../apertium-en-es.es.dix ../es-en.automorf.bin ../apertium-en-es.es.tsx > lang.dic

    $> apertium-xtract-regex-trules ../apertium-en-es.es-en.t1x > regexp-trules.txt

Now we should scape the '#' characters, otherwise we will have the a 'lcre_missing )' error

    $> cp ../../apertium-tagger-training-tools/example/translation-script-es-ca-batch-mode.sh .

    $> mv translation-script-es-ca-batch.sh translation-script-es-ca-batch-mode.sh

Now we should edit the DATA and DIRECTION variables to get them as 

    DATA=<path to en-es folder>

    DIRECTION=es-en

As this language has no three-stage transfer we just have to leave the script.sh file as it is

To prepare the likelihood script we just copy it from apertium-tagger-training-tools to this folder:

    $> cp ../../apertium-tagger-training-tools/example/likelihood-script-catalan-batch-mode.sh .

    $> mv likelihood-script-catalan-batch-mode.sh likelihood-script-spanish-batch-mode.sh

and modify it changing the LMDATA as follow:

    LMDATA=spanish.lm

Finally to get the probability file we use:

    $> apertium-tagger-tl-trainer --train 500000 --tsxfile ../apertium-en-es.es.tsx --file lang --tscript ./translation-script-es-ca-batch-mode.sh --lscript ./likelihood-script-spanish-batch-mode.sh --trules regexp-trules.txt

Once finished we will have the es.prob file obtained with a supervised maner 

Author: tuxskar
