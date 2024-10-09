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


The raw data was downloaded from DArT-Seq:
	
  	wget --header 'Authorization: Bearer HIDDEN_KEY' -r -nd -nH --include-directories=clients https://ordering.diversityarrays.com/list_files.pl

Md5Sums were checked 
  
  	sbatch checkMD5.sh 

Create environment with dependencies:

  	mamba env create -f hop_analysis
