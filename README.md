# IUK climate resilient UK hop collaboration 

Dr Helen Cockerton (UoK), Dr Klara Hajdu (Wye Hops), Dr John Connell (NIAB)


                                                                                                 
                                                             @@&                                 
                                                          &@  @@@                                
                                                        ,@ #@,                                   
                                                       @@ @                                      
                                                       @,@                                       
                                                      @%@                                        
                                                      @#@                                        
                                               @@@@@@@@@@@@@@@@@,                                
                                         %@@      @@, *@@  @@*     @@@                           
                                      #@(      @@    @@ .@,   @@       @@                        
                                    #@ /@@@@@@@   @@.@   @ @@   @@@@@@@# @@                      
                                   *@@     *@#@@@    @@ &@    @@@@@@     &@**                    
                                  #@        *@        @.@        @@        @@                    
                                 @@         @%         @.         @         %@                   
                                &@         @@        .@%@         @@         @@                  
                                @,      .@@ &@      @#   @@      @@ @@.       @                  
                                @  @@@       @@ #@@         @@@ @@       %@@  @                  
                                @@@*        @&@@*@    HOP    @#@@,@         @@@                  
                                  @        @@    ,@         @(    @@        @                    
                                  @       @@       @@     @@       @@       @                    
                                  @.    @@@        @@@@ @@/@        @@@     @                    
                                  @@  @@  @@      (@   (   @@      %@  @@  &@                    
                                   @@@@@   @@    @,          @#   @@   ,@@@@                     
                                    ( @@    @@@@@@(          @%@(@@    /@                        
                                       @    @     @@       @@     @    @*                        
                                        @  @@       @@   #@.      @@  @#                         
                                         @@ @@     .@ .@& @@     @@ @@                           
                                             @@   /@       @@   @@                               
                                               @@@@@      .@,@@@                                 
                                                    @@   @@                                      
                                                      &@@       


Download raw data from DArT-Seq:
	
  	wget --header 'Authorization: Bearer HIDDEN_KEY' -r -nd -nH --include-directories=clients https://ordering.diversityarrays.com/list_files.pl

Check MD5 sums: 
  
  	sbatch checkMD5.sh 

Create conda environment with dependencies:

  	mamba env create -f hop_analysis


Run analysis pipeline: 

	sbatch hop_analysis.sh 
