import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

import java.sql.Array;
import java.util.*;
import java.util.stream.Collectors;

public class Top10MutualFriends {
    public static class MapClass extends Mapper<LongWritable, Text, Text, Text> {
        Text user = new Text();
        Text friends = new Text();

        public void map(LongWritable key, Text value, Context context)
                throws IOException, InterruptedException {
            // Splitting each line into user and corresponding friend list
            String[] split = value.toString().split("\\t");
            // split[0] is user and split[1] is friend list
            String userId = split[0];
            user.set(userId);
            
            // Emit the user with its own friend list
            if (split.length == 1) {
                friends.set("-1");
                context.write(user, friends);
                return;
            } else {
                friends.set(split[1] + "-1");
                context.write(user, friends);
            }

            String[] friendIds = split[1].split(",");
            
            // Emit potential mutual friend for each friends
            for (String friend : friendIds) {
                String commonFriends = Arrays.stream(friendIds).filter(f -> !f.equals(friend)).collect(Collectors.joining(","));
                friends.set(commonFriends + "-0");
                user.set(friend);
                context.write(user, friends);
            }
        }
    }

    public static class Reduce
            extends Reducer<Text, Text, Text, Text> {
        public void reduce(Text key, Iterable<Text> values, Context context)
                throws IOException, InterruptedException {
            HashMap<String, Integer> dict = new HashMap();
            String[] ownFriends = {};

            // Populate a dictionnary with a userId as the key and a value representing the number of mutual friend they have with them
            for (Text value : values) {
                String[] friendsAndIndicator = value.toString().split("-");
                String[] friends = friendsAndIndicator[0].split(",");
                if (friends.length == 1 && friends[0].equals("")) continue;
                if (friendsAndIndicator[1].equals("1")) {
                    ownFriends = friends;
                } else {
                    for (String friend : friends) {
                        dict.put(friend, dict.getOrDefault(friend, 0) + 1);
                    }
                }
            }
            
            // Remove their own friend from the dictionnary
            dict.remove("");
            for (String friend : ownFriends) {
                dict.remove(friend);
            }
            
            // Sort the dictionnary and get the 10 users with the most number of mutual friends with them
            Comparator<Map.Entry<String, Integer>> comparator = ((x, y) -> y.getValue().compareTo(x.getValue()));
            comparator = comparator.thenComparing(x -> x.getKey());
            String sortedFriends = dict.entrySet()
                    .stream()
                    .sorted(comparator)
                    .limit(10)
                    .map(Map.Entry::getKey)
                    .collect(Collectors.joining(","));

            context.write(key, new Text(sortedFriends));
        }

    }


    // Driver program
    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
        // get all args
        if (otherArgs.length != 2) {
            System.err.println("Usage: MutualFriends <input file name> <output file name>");
            System.exit(2);
        }

        // create a job with name "mutual friends"
        @SuppressWarnings("deprecation")
        Job job = new Job(conf, "mutualfriends");
        job.setJarByClass(Top10MutualFriends.class);
        job.setMapperClass(MapClass.class);
        job.setReducerClass(Reduce.class);


        // uncomment the following line to add the Combiner job.setCombinerClass(Reduce.class);


        // set output key type
        job.setOutputKeyClass(Text.class);
        // set output value type
        job.setOutputValueClass(Text.class);
        //set the HDFS path of the input data
        FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
        // set the HDFS path for the output
        FileOutputFormat.setOutputPath(job, new Path(otherArgs[1]));
        //Wait till job completion
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
