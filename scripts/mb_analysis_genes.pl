#!/usr/bin/perl -w

# This script automates the MrBayes analyses of all individual genes.

# example of use: nohup perl mb_analysis.pl geneRowNb=1 Ngenes=1 fullrun &

# Options
#  geneRowNb:   gene to analyze first: listed on row geneRowNb. (default 3)
#               for instance: listfiles100.nex has "11959.nex" on its 3rd row.
#  Ngenes:      # genes to analyze, sequentially (default 1)
#
#  ngen:        # generations (default 550)
#  samplefreq:  sampling frequency for MrBayes (default 50)
#  mbsumburnin: burnin for mbsum (default 2)
#  nruns:       # independent runs (default 2)
#  temp:        temperature (default 0.2)
#  Nchains:     number of chains (1 cold, others heated. Default 4)
#  swapfreq:    swap frequency between chains (default 10)
#  diagnfreq:   diagnostic frequency for MrBayes (to screen)
#  printfreq:   printing frequency (to screen and mcmc file)
#  fullrun:     Shortcut. sets ngen=110000, nruns=2, samplefreq=10
#               -> 11001 sampled trees from each run, mbsumburnin=1001
#                  to keep 10000 trees from each run,
#               printfreq=50000, diagnfreq=50000.
# 

# Other model choices, hardcoded: HKY+Gamma model for all genes,
# Exponential prior distribution for branch lengths, with prior mean
#             0.02 substitutions/site.

#------ Setting file names ------------------#
$dir = "";
# change $dir above if script is not run from the buckyTutorial directory.
$datadir = $dir . "genes/nex/";
$fileOfFilenames = "genes_files.txt";
$mbdir = $dir . "genes/";
# will contain mb command & output files and mbsum output files.

#------- Command names and default options --#
$mb      = "mb";
$mbsum   = "mbsum";

$geneRowNb=1;
$Ngenes = 927;

#------- default MrBayes parameters ---------#
$nst   = 6;       # HKY model. Use $nst = 6 for GTR
$rates = "invgamma"; # rate variation across sites: Gamma distribution
                  # use "invgamma" for Gamma+I
$ngen=550;
$nruns=2;           #run two independent alaysis in parallel
$mbsumburnin=5;
$diagnfreq=50;
$samplefreq=10;
$printfreq=50;
$temp=0.2;
$Nchains=4;
$swapfreq=10;
# $Nswaps=1;

#-- reads arguments -----------------------#
foreach (@ARGV){
  if (/\bgeneRowNb=(\d+)/i){$geneRowNb=$1; }
  if (/\bNgenes=([\d+]+)/i){$Ngenes=$1; }
  if (/\bngen=([\d+]+)/i){ $ngen=$1; }
  if (/\bnruns=(\d+)/i){   $nruns=$1;  }
  if (/\btemp=([\d.]+)/i){ $temp=$1;  }
  if (/\bmbsumburnin=(\d+)/i){$mbsumburnin=$1; }
  if (/\bdiagnfreq=(\d+)/i){$diagnfreq=$1; }
  if (/\bsamplefreq=(\d+)/i){$samplefreq=$1;}
  if (/\bprintfreq=(\d+)/i){ $printfreq=$1; }
  if (/\bswapfreq=(\d+)/i){  $swapfreq=$1; }
  # if (/\bNswaps=(\d+)/i){    $Nswaps=$1; }
  if (/\bNchains=(\d+)/i){   $Nchains=$1; }
  if (/\bfullrun/i){        # parameters when full run is specified
    $nruns       = 2;
    $ngen        = 110000; #
    $samplefreq  =  10  ; # determines how often the chain is sampled
    $mbsumburnin =  1001 ;
    $printfreq   =  50000;  # prints loglik to screen
    $diagnfreq   =  50000;  # prints diagn. to screen + .mcmc file
                            # but only after 10*burnin generations!!
  }
  # burnin for MrBayes is calculated from intended burnin for mbsum:
  $mbburnin    =  ($mbsumburnin-1) * $samplefreq;
  $mbburninfrac= $mbburnin/$ngen;
  die ("Burnin too high\n") if ($mbburninfrac>=1);
  if ($Ngenes<=0){
   die ("invalid Ngenes $Ngenes: must be positive.\n");
  }
  if ($geneRowNb<1 or $geneRowNb+$Ngenes>1000){
   die("invalid geneRowNb $geneRowNb or Ngenes $Ngenes. We have less than 1000 genes.\n");
  }
}

#------- read gene names to get their nexus file names --------#
#                                                              #
#                                                              #

@gene = ();
open FHi, "<$dir$fileOfFilenames";
$row = 1;
while (<FHi>){
 if ($row >= $geneRowNb and $row < ($geneRowNb + $Ngenes)){
  chomp;
  if (/^(.*?)\./){$geneID=$1; } # gene name matched to whatever is before "."
  push @gene, $geneID;
 }
 $row++;
 if ($row >= ($geneRowNb + $Ngenes)){ last;}
}
close FHi;

#-------- Starting the analysis -------------------------------#

# log file will be created:
$logFile = $dir . $gene[0] ."to". $gene[$Ngenes-1] . ".log";

$startTime = time();
print "\n\nIndividual MrBayes analysis, gene(s) on row $geneRowNb and up\n\n";

open FHlog, ">>$logFile";
writeparameters();
print FHlog "MrBayes run: gene name, row, average SD of split freq:\n";


foreach $rowNb (0..($Ngenes-1)){
 # warning: rowNb starts at 0. rowNb corresponds to row $geneRowNb+$rowNb.
 $gene = $gene[$rowNb];
 $file = $datadir . $gene . ".nex";
 print "Running MrBayes on gene $gene (row # " . ($geneRowNb+$rowNb) .")... ";
 print FHlog "\t$gene\t" . ($geneRowNb+$rowNb) ."...\t";

 $nohupfile = $mbdir . $gene . ".nohup";
 $mbfile    = $mbdir . $gene[0] ."to". $gene[$Ngenes-1] . ".nex";
 $mbOutFile = "$mbdir$gene";

 open FHnh, ">$nohupfile";
 print FHnh "Analysis of $file (row # " . ($geneRowNb+$rowNb) .") started on ";
 print FHnh `date`;
 print FHnh "\n";
 close FHnh;

#----------- create a MrBayes command file -------------#
#         read in nexus data + execute mrbayes block    #

 open FHo, ">$mbfile";
 # this file gets overwritten for each new gene analysis.
 print FHo "#nexus\nbegin mrbayes;\n";
 print FHo "set autoclose=yes nowarn=yes;\n";
 print FHo "execute $file;\n\n";
 
 print FHo "lset nst=$nst rates=$rates;\n";
 print FHo "prset brlenspr=Unconstrained:Exp(50.0);\n";
 # above: prior mean of 1/50=0.02 for branch lengths.
 print FHo "mcmc nruns=$nruns temp=$temp ngen=$ngen burninfrac=$mbburninfrac Nchains=$Nchains ";
 print FHo "samplefreq=$samplefreq swapfreq=$swapfreq printfreq=$printfreq ";
 print FHo "mcmcdiagn=yes diagnfreq=$diagnfreq ";
 print FHo "filename=$mbOutFile;\n";

 # bucky does not need the consensus tree. 
 # If you want to get it anyway, uncomment the next line:
 # print FHo "sumt nruns=$nruns filename=$mbOutFile burnin=$mbsumburnin;\n";
 print FHo "quit;\nend;\n";
 close FHo;

#----------- run MrBayes --------------------------#
#    genes are run sequentially, one after another #

 system("mpirun -np 2 $mb $mbfile >> $nohupfile");

 # removing files we won't need:
 system("rm -f $mbdir$gene.run?.p");
 unlink("$mbdir$gene.mcmc");
 unlink("$mbdir$gene.ckp");
 # If the 'sumt' command was included to get the consensus tree,
 # uncomment the following 3 lines:
 # unlink("$mbdir$gene.parts");
 # unlink("$mbdir$gene.tstat");
 # unlink("$mbdir$gene.vstat");
 # unlink("$mbdir$gene.trprobs");

 open FHnh, ">>$nohupfile";
 print FHnh "Analysis of $file (row # " . ($geneRowNb+$rowNb) .") ended on ";
 print FHnh `date`;
 print FHnh "\n";
 close FHnh;

#----------- extract average SD of split freq ------#
#            from .nohup file                       #
 $avSD = "not found yet";
 open FHnh, "<$nohupfile";
 while (<FHnh>){
  if (/Average standard deviation of split frequencies: (\d\.\d+)/){$avSD=$1;}
 }
 close FHnh;
 print FHlog "$avSD\n";
 print       "$avSD\n";

#----------- run mbsum -----------------------------#
#     to combine all runs from the gene, and        #
#     calculate all P(T|gene) with a standardized   #
#     representation of each tree                   #

 system("$mbsum -n $mbsumburnin -o $mbOutFile.in $mbOutFile.run?.t >> $nohupfile");
 # remove the unnecessary .t files, which can be very big:
 system("rm -f $mbdir$gene.run?.t");

}

#----------- wrap up -------------------------------#

$endTime = time();
$duration = $endTime - $startTime;
if ($duration<60){ $durationstring = "$duration second(s)";}
else{ 
  $sec = $duration % 60;
  $duration = ($duration - $sec)/60;
  $durationstring = "$sec second(s)";
  if ($duration<60){ $durationstring = "$duration minute(s) and $durationstring";}
  else{
   $min = $duration % 60;
   $duration = ($duration - $min)/60;
   $durationstring = "$min minute(s) and $durationstring";
   if ($duration<24){ $durationstring = "$duration hour(s), $durationstring";}
   else{
    $hou = $duration % 24;
    $day = ($duration-$hou)/24;
    $durationstring = "$day day(s), $hou hour(s), $durationstring";
 }}}
print       localtime($endTime) . " -- It took $durationstring.\n";
print FHlog localtime($endTime) . " -- It took $durationstring.\n";
close FHlog;


#---------------- subroutine: Log parameters ----------------------#

sub writeparameters {
 print FHlog "-------------------------------\n";
 print       localtime($startTime) . "\n";
 print FHlog localtime($startTime) . "\n";

 print FHlog "Output parameters:\n";
 print FHlog " gene rows                  = ";
 print FHlog $geneRowNb ." through " . ($geneRowNb+$Ngenes-1) ."\n";

 print FHlog "\nMrBayes estimation parameters:\n";
 print FHlog " temperature     = $temp\n";
 print FHlog " nst             = $nst\n";
 print FHlog " rates           = $rates\n";
 print FHlog " nb runs         = $nruns\n";
 print FHlog " nb generations  = $ngen\n";
 print FHlog " sampling freq.  = $samplefreq\n";
 print FHlog " mbsum burnin    = $mbsumburnin\n";
 print FHlog " mb    burnin    = $mbburnin\n";
 print FHlog " print frequency (.log) = $printfreq\n";
 print FHlog " diagnostic freq (.mcmc)= $diagnfreq\n";

 print FHlog "\n";
}
