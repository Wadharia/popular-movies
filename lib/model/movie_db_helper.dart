import 'package:path/path.dart';
import 'package:popular_movies/model/movie_bean.dart';
import 'package:popular_movies/model/movie_detail_bean.dart';
import 'package:sqflite/sqflite.dart';

class MovieDBHelper {
  static int versionNo = 2;
  static String DATABASE_NAME = "movieDB.db";

  static String TABLE_MOVIE_DETAIL = "MOVIEDETAIL";
  static String COLUMN_MOVIE_ID = "movieID";
  static String COLUMN_moviePosterUrl = "moviePosterUrl";
  static String COLUMN_title = "title";
  static String COLUMN_releaseDate = "releaseDate";
  static String COLUMN_voteAverage = "voteAverage";
  static String COLUMN_overview = "overview";
  static String COLUMN_detailPosterUrl = "detailPosterUrl";
  static String COLUMN_moviePosterFile = "moviePosterFile";
  static String COLUMN_detailPosterFile="detailPosterFile";


  static String TABLE_MOVIE_TRAILER = "MOVIETRAILER";

//  static String COLUMN_MOVIE_ID = "movieID";
  static String COLUMN_trailerName = "trailerName";
  static String COLUMN_trailerURL = "trailerURL";

  Future<Database> initDB() async {
    return openDatabase(
      join(await getDatabasesPath(), DATABASE_NAME),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        String createMovieDetails =
            "CREATE TABLE IF NOT EXISTS ${TABLE_MOVIE_DETAIL} " +
                "(${COLUMN_MOVIE_ID} TEXT PRIMARY KEY, " +
                "${COLUMN_moviePosterUrl} TEXT, " +
                "${COLUMN_title} TEXT, " +
                "${COLUMN_releaseDate} TEXT, " +
                "${COLUMN_voteAverage} TEXT, " +
                "${COLUMN_overview} TEXT, " +
                "${COLUMN_moviePosterFile} TEXT, " +
                "${COLUMN_detailPosterFile} TEXT, " +
                "${COLUMN_detailPosterUrl} TEXT)";

        String createMovieTrailer =
            "CREATE TABLE IF NOT EXISTS ${TABLE_MOVIE_TRAILER} " +
                "(${COLUMN_MOVIE_ID} TEXT PRIMARY KEY, " +
                "${COLUMN_trailerName} TEXT, " +
                "${COLUMN_trailerURL} TEXT)";

        await db.execute(createMovieDetails);
        await db.execute(createMovieTrailer);
      },
      version: versionNo,
      onUpgrade: (db, oldVersion, newVersion) async{
        if(oldVersion<newVersion) {

          //We cannot use alter table to drop primary key in sqlite

          String createMovieTrailer =
              "CREATE TABLE IF NOT EXISTS ${TABLE_MOVIE_TRAILER}_copy " +
                  "(${COLUMN_MOVIE_ID} TEXT, " +
                  "${COLUMN_trailerName} TEXT, " +
                  "${COLUMN_trailerURL} TEXT)";
          await db.execute(createMovieTrailer);
          String copyMovieTrailer =
              "INSERT INTO ${TABLE_MOVIE_TRAILER}_copy " +
                  "(${COLUMN_MOVIE_ID}, " +
                  "${COLUMN_trailerName}, " +
                  "${COLUMN_trailerURL}) "
                  "SELECT " +
                  "${COLUMN_MOVIE_ID}, " +
                  "${COLUMN_trailerName}, " +
                  "${COLUMN_trailerURL} " +
                  "FROM ${TABLE_MOVIE_TRAILER} ";

          await db.execute(copyMovieTrailer);


          String dropMovieTrailer =
              "DROP TABLE ${TABLE_MOVIE_TRAILER}";
          await db.execute(dropMovieTrailer);


          String renameMovieTrailer =
              "ALTER TABLE ${TABLE_MOVIE_TRAILER}_copy " +
              "RENAME TO ${TABLE_MOVIE_TRAILER} ";
          await db.execute(renameMovieTrailer);
        }
      },

    );
  }

  Future<void> insertMovieDetail(MovieDetailBean movieDetailBean) async {
    // Get a reference to the database.
    final Database db = await initDB();

    await db.insert(
      TABLE_MOVIE_DETAIL,
      movieDetailBean.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (movieDetailBean.movieTrailers!.isNotEmpty) {
      MovieTrailerBean stubBean;
      for (stubBean in movieDetailBean.movieTrailers!) {
        stubBean.movieID = movieDetailBean.movieID!;
        await insertMovieTrailer(stubBean, db);
      }
    }
   await db.close();
  }

  Future<void> insertMovieTrailer(MovieTrailerBean movieTrailerBean,
      Database db) async {
    // Get a reference to the database.
//    final Database db = await initDB();

    await db.insert(
      TABLE_MOVIE_TRAILER,
      movieTrailerBean.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

//    db.close();
  }


  Future<void> deleteMovieDetail(MovieDetailBean movieDetailBean) async {
    // Get a reference to the database.
    final Database db = await initDB();

    await deleteMovieTrailer(movieDetailBean, db);

    await db.delete(
      TABLE_MOVIE_DETAIL,
    where: "${COLUMN_MOVIE_ID} = ?",
    whereArgs: [movieDetailBean.movieID],
    );

    db.close();
  }

  Future<void> deleteMovieTrailer(MovieDetailBean movieDetailBean, Database db) async {
    // Get a reference to the database.
//    final Database db = await initDB();
    await db.delete(
      TABLE_MOVIE_TRAILER,
      where: "${COLUMN_MOVIE_ID} = ?",
      whereArgs: [movieDetailBean.movieID],
    );

//    db.close();
  }



  Future<List<MovieDetailBean>> getFavouriteMovieList() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(TABLE_MOVIE_DETAIL);
    List<MovieDetailBean> retList= List.generate(maps.length, (i) {
      return MovieDetailBean(
        moviePosterUrl: maps[i][COLUMN_moviePosterUrl],
        overview: maps[i][COLUMN_overview],
        voteAverage: maps[i][COLUMN_voteAverage],
        releaseDate: maps[i][COLUMN_releaseDate],
        title: maps[i][COLUMN_title],
        detailPosterUrl: maps[i][COLUMN_detailPosterUrl],
        movieID: maps[i][COLUMN_MOVIE_ID],
        moviePosterFile: maps[i][COLUMN_moviePosterFile],
        detailPosterFile: maps[i][COLUMN_detailPosterFile],
        isOffline: true
      );
    });

    await db.close();

    return retList;
  }

  Future<List<MovieDetailBean>> getStoredMovieDetails(MovieDetailBean movieDetailBean) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(TABLE_MOVIE_DETAIL,
      // Use a `where` clause to delete a specific dog.
      where: "${COLUMN_MOVIE_ID} = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [movieDetailBean.movieID],);
    List<MovieDetailBean> retList= List.generate(maps.length, (i) {
      return MovieDetailBean(
          moviePosterUrl: maps[i][COLUMN_moviePosterUrl],
          overview: maps[i][COLUMN_overview],
          voteAverage: maps[i][COLUMN_voteAverage],
          releaseDate: maps[i][COLUMN_releaseDate],
          title: maps[i][COLUMN_title],
          detailPosterUrl: maps[i][COLUMN_detailPosterUrl],
          movieID: maps[i][COLUMN_MOVIE_ID]
      );
    });

    await db.close();

    return retList;
  }


  Future<List<MovieTrailerBean>> getStoredTrailerDetails(MovieDetailBean movieDetailBean) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(TABLE_MOVIE_TRAILER,
      where: "${COLUMN_MOVIE_ID} = ?",
      whereArgs: [movieDetailBean.movieID],);

    List<MovieTrailerBean> retList= List.generate(maps.length, (i) {
      return MovieTrailerBean(
          trailerURL: maps[i][COLUMN_trailerURL],
          trailerName: maps[i][COLUMN_trailerName]
      );
    });

    await db.close();

    return retList;
  }




}